from flask import Flask, jsonify, request
from prophet import Prophet
import pandas as pd
import json
import requests
from datetime import datetime

app = Flask(__name__)

def obtener_datos_api(cod_socio):
    url = f"http://192.168.0.19/mimedidor_api/get_consumo_historial_completo.php?cod_socio={cod_socio}"
    try:
        respuesta = requests.get(url)
        texto = respuesta.text.strip()
        json_start = texto.find("{")
        texto = texto[json_start:]
        data = json.loads(texto)
        df = pd.DataFrame(data["historial"])
        df['ds'] = pd.to_datetime(df['anio'].astype(str) + '-' + df['mes'].astype(str).str.zfill(2) + '-01')
        df.rename(columns={'consumo': 'y'}, inplace=True)
        return df[['ds', 'y']]
    except Exception as e:
        print(f"Error: {e}")
        return None

@app.route('/api/prediccion', methods=['GET'])
def prediccion():
    cod_socio = request.args.get('cod_socio')
    if not cod_socio:
        return jsonify({'error': 'Se requiere el parámetro cod_socio'}), 400

    df = obtener_datos_api(cod_socio)
    if df is None or df.empty:
        return jsonify({'error': 'No se encontraron datos históricos'}), 404

    modelo = Prophet(yearly_seasonality=True)
    modelo.add_seasonality(name='monthly', period=30.5, fourier_order=5)
    modelo.fit(df)

    anio_actual = datetime.now().year

    fecha_fin = pd.Timestamp(f"{anio_actual}-12-31")
    dias_restantes = (fecha_fin - df['ds'].max()).days
    futuro = modelo.make_future_dataframe(periods=dias_restantes, freq='D')
    forecast = modelo.predict(futuro)

    forecast_anio = forecast[forecast['ds'].dt.year == anio_actual].copy()
    forecast_anio['mes'] = forecast_anio['ds'].dt.month
    forecast_anio['dia'] = forecast_anio['ds'].dt.day
    forecast_anio['yhat'] = forecast_anio['yhat'].round(2)

    consumo_mensual = forecast_anio[forecast_anio['dia'] == 1][['mes', 'yhat']].rename(columns={'yhat': 'consumo'})

    resumen = forecast_anio.groupby('mes')['yhat'].agg(['min', 'max']).reset_index().round(2)
    resultado_final = pd.merge(consumo_mensual, resumen, on='mes')
    resultado_final = resultado_final.rename(columns={'min': 'minimo', 'max': 'maximo'})

    resultado = []
    for _, row in resultado_final.iterrows():
        consumo = round(row['consumo'], 2)
        minimo = max(10.0, round(row['minimo'], 2))
        maximo = round(row['maximo'], 2)

        if minimo >= consumo:
            minimo = max(10.0, consumo - 1.0)
        if maximo <= consumo:
            maximo = consumo + 1.0

        resultado.append({
            "mes": str(int(row['mes'])).zfill(2),
            "consumo": consumo,
            "minimo": round(minimo, 2),
            "maximo": round(maximo, 2)
        })

    return jsonify({
        "anio": anio_actual,
        "prediccion_mensual": resultado
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
