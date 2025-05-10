import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactoScreen extends StatelessWidget {
  const ContactoScreen({super.key});

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'consulta@saguapac.com.bo',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchWhatsapp() async {
    const whatsappNumber = '59178000333';
    final url = Uri.parse('https://wa.me/$whatsappNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _launchPhone(String number) async {
    final url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _launchMaps() async {
    const url = 'https://www.google.com/maps/search/?api=1&query=Av.+Rio+Grande+2323,+Santa+Cruz,+Bolivia';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Servicio al Cliente"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _launchEmail,
                child: const Text(
                  "Email\nconsulta@saguapac.com.bo",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Reclamos y Emergencias (24 hrs)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              GestureDetector(
                onTap: () => _launchPhone("3531115"),
                child: const Text("353-1115", style: TextStyle(color: Colors.black)),
              ),
              GestureDetector(
                onTap: () => _launchPhone("800178178"),
                child: const Text("800-178178", style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _launchWhatsapp,
                    child: const Text("Whatsapp\n78000333", style: TextStyle(color: Colors.black)),
                  ),
                  GestureDetector(
                    onTap: () => _launchPhone("3522323"),
                    child: const Text("Oficina\n352-2323", style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _launchMaps,
                child: const Text(
                  "Ubicación\nOf. Central: Av. Río Grande 2323, Santa Cruz de la Sierra. Bolivia",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
