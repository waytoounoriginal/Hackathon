import 'package:intl/intl.dart';

class Person {
  String? id;
  String? fullName;
  String? userName;
  String? type;
  String? userCountry;
  String? lastIP;
  String? email;
  String? phoneNo;
  String? dateCreated;
  Fingerprint fingerprint;

  Person({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.type,
    required this.userCountry,
    required this.lastIP,
    required this.email,
    required this.phoneNo,
    required this.dateCreated,
    required this.fingerprint,
  });

  Map toJson() => {
        "ID": id,
        "Full Name": fullName,
        "Username": userName,
        "Type": type,
        "User Country": userCountry,
        "Last IP": lastIP,
        "Email": email,
        "Phone Number": phoneNo,
        "Date Created": dateCreated,
        "Fingerprint": fingerprint
      };

  Person fromJSON(Map json, Map fingerprintJSON) {

    Fingerprint _fprint = Fingerprint.fromJSON(fingerprintJSON);


    return  Person(
        id: json['id'],
        dateCreated: json['usercreated'],
        email: json['email'],
        fingerprint: _fprint,
        fullName: json['fullname'],
        lastIP: json['iptable'],
        phoneNo: json['phonenumber'],
        type: int.parse(_fprint.score ?? '11') > 10 ? 'Fraudulent' : 'Normal',
        userCountry: _fprint.country,
        userName: json['username'],
      );
  }

  List<List<String>> toList() => [
        ["ID:", id.toString()],
        ["Full Name:", fullName ?? "NULL"],
        ["Username:", userName ?? "NULL"],
        ["Full Name:", fullName ?? "NULL"],
        ["Type:", type ?? "NULL"],
        ["User Country:", userCountry ?? "NULL"],
        ["Last IP:", lastIP ?? "NULL"],
        ["Email:", email ?? "NULL"],
        ["Phone Number:", phoneNo ?? "NULL"],
        ["Date Created:", dateCreated ?? "NULL"],
      ];
}

class Fingerprint {
  String? score;
  String? country;
  String? stateprov;
  String? city;
  String? timezone;
  String? lat;
  String? long;

  String? dnsip;

  String? dnsipcountry;

  String? dnsipisp;

  String? regiontime;

  String? deviceip;

  String? deviceipcountry;

  String? deviceipisp;

  String? vpn;
  String? tor;
  String? webproxy;
  String? publicproxy;
  String? private;

  Fingerprint({
    required this.score,
    required this.country,
    required this.stateprov,
    required this.city,
    required this.timezone,
    required this.lat,
    required this.long,
    required this.dnsip,
    required this.dnsipcountry,
    required this.dnsipisp,
    required this.regiontime,
    required this.deviceip,
    required this.deviceipcountry,
    required this.deviceipisp,
    required this.vpn,
    required this.tor,
    required this.webproxy,
    required this.publicproxy,
    required this.private,
  });

  //  DEBUG
  static final Map<String, dynamic> dummyInfo = {
    "device_details": {
      "session_id": "test_session",
      "type": "android",
      "dns_ip": "89.134.46.87",
      "dns_ip_country": "HU",
      "dns_ip_isp": "UPC Magyarorszag Kft.",
      "source": "android-4.1.0",
      "device_hash":
          "702ec69fa2538ed37ddca2d29210bba6f7801ab9cf2f47bdec260f5dc84fd9cc",
      "device_name": "LGE LG-H502",
      "device_cellular_id": "352104070316496",
      "android_id": "9cb5c5698c590fdc",
      "build_id": "MRA58K",
      "build_device": "my90ds",
      "build_time": 1550069867,
      "build_number": "MRA58K",
      "build_manufacturer": "LGE",
      "app_guid": "66dc9430-a09f-4dcb-ab16-cd5b1c3d7316",
      "android_version": "23 (6.0)",
      "last_boot_time": 1623315851,
      "system_uptime": 495,
      "sensor_hash":
          "ea8170d27b08a39d3a697c9da5e8c0190174ebb302fc35e77da17690abb61576",
      "audio_volume_current": 28,
      "audio_mute_status": true,
      "battery_level": 80,
      "battery_charging": false,
      "battery_temperature": 29,
      "battery_voltage": 4063,
      "battery_health": "GOOD",
      "has_proximity_sensor": true,
      "cpu_type": "ARMv7 Processor rev 3 (v7l)",
      "cpu_count": 4,
      "cpu_speed": 1300,
      "cpu_hash":
          "6bae8487b6bd0d18f12910a12d79b43e79a21f8fa11bb0b44ca15b6a9f4c5cbe",
      "kernel_name": "Linux",
      "kernel_version": "3.10.72",
      "kernel_arch": "armv7l",
      "physical_memory": 979608000,
      "screen_brightness": 100,
      "screen_height": 1187,
      "screen_width": 720,
      "screen_scale": 2,
      "total_storage": 3854680064,
      "free_storage": 395546624,
      "network_config": "WIFI",
      "wifi_mac_address": "64:BC:0C:91:DC:01",
      "wifi_ssid": "WIFI_SSID",
      "carrier_name": null,
      "pasteboard_hash":
          "50ba875a2d572ed0c2632d3920d73a827588f0d86500b2e3145a788c86fdc83c",
      "region_timezone": "+02:00",
      "region_language": "en",
      "region_country": "GB",
      "carrier_country": null,
      "is_emulator": false,
      "is_rooted": false,
      "device_ip_address": "84.2.42.16",
      "device_ip_country": "HU",
      "device_ip_isp": "Magyar Telekom"
    }
  };

  List<List<String>> toList() => [
        ["Has VPN:", vpn.toString()],
        ["Has WebProxy:", webproxy.toString()],
        ["Has PublicProxy:", publicproxy.toString()],
        ["Is Private:", private.toString()],
        ["Is TOR:", tor.toString()],
        ["Score:", score.toString()],
        ["Country:", country ?? "NULL"],
        ["State Province:", stateprov ?? "NULL"],
        ["City:", city ?? "NULL"],
        ["Timezone:", timezone ?? "NULL"],
        ["Latitude:", lat.toString()],
        ["Longitude:", long.toString()],
        ["DNS IP:", dnsip ?? "NULL"],
        ["DNS Country:", dnsipcountry ?? "NULL"],
        ["DNS ISP:", dnsipisp ?? "NULL"],
        ["Region Time:", regiontime ?? "NULL"],
        ["Device IP:", deviceip ?? "NULL"],
        ["Device Country:", deviceipcountry ?? "NULL"],
        ["Device ISP:", deviceipisp ?? "NULL"],
      ];

  static Fingerprint fromJSON(Map json) => Fingerprint(
      score: json['score'] ?? "NULL",
      country: json['country'] ?? "NULL",
      stateprov: json['stateprov'] ?? "NULL",
      city: json['city'] ?? "NULL",
      timezone: json['timezone'] ?? "NULL",
      lat: json['lat'] ?? "NULL",
      long: json['long'] ?? "NULL",
      dnsip: json['dnsip'] ?? "NULL",
      dnsipcountry: json['dnsipcountry'] ?? "NULL",
      dnsipisp: json['dnsipisp'] ?? "NULL",
      regiontime: json['regiontime'] ?? "NULL",
      deviceip: json['deviceip'] ?? "NULL",
      deviceipcountry: json['deviceipcountry'] ?? "NULL",
      deviceipisp: json['deviceipisp'] ?? "NULL",
      vpn: json['vpn'] ?? "NULL",
      tor: json['tor'] ?? "NULL",
      webproxy: json['webproxy'] ?? "NULL",
      publicproxy: json['publicproxy'] ?? "NULL",
      private: json['private'] ?? "NULL");
}
