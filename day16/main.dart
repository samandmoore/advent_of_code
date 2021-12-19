import 'dart:math';

void main() {
  // var packet = parsePacket(convertPacketHexToBinary("C200B40A82"));
  // print(reducePackets(packet) == 3);

  // packet = parsePacket(convertPacketHexToBinary("04005AC33890"));
  // print(reducePackets(packet) == 54);

  // packet = parsePacket(convertPacketHexToBinary("880086C3E88112"));
  // print(reducePackets(packet) == 7);

  // packet = parsePacket(convertPacketHexToBinary("CE00C43D881120"));
  // print(reducePackets(packet) == 9);

  // packet = parsePacket(convertPacketHexToBinary("D8005AC2A8F0"));
  // print(reducePackets(packet) == 1);

  // packet = parsePacket(convertPacketHexToBinary("F600BC2D8F"));
  // print(reducePackets(packet) == 0);

  // packet = parsePacket(convertPacketHexToBinary("9C005AC2F8F0"));
  // print(reducePackets(packet) == 0);

  // packet = parsePacket(convertPacketHexToBinary("9C0141080250320F1802104A08"));
  // print(reducePackets(packet) == 1);

  partTwo();
}

void partOne() {
  final packets = parsePacket(convertPacketHexToBinary(
      "E0529D18025800ABCA6996534CB22E4C00FB48E233BAEC947A8AA010CE1249DB51A02CC7DB67EF33D4002AE6ACDC40101CF0449AE4D9E4C071802D400F84BD21CAF3C8F2C35295EF3E0A600848F77893360066C200F476841040401C88908A19B001FD35CCF0B40012992AC81E3B980553659366736653A931018027C87332011E2771FFC3CEEC0630A80126007B0152E2005280186004101060C03C0200DA66006B8018200538012C01F3300660401433801A6007380132DD993100A4DC01AB0803B1FE2343500042E24C338B33F5852C3E002749803B0422EC782004221A41A8CE600EC2F8F11FD0037196CF19A67AA926892D2C643675A0C013C00CC0401F82F1BA168803510E3942E969C389C40193CFD27C32E005F271CE4B95906C151003A7BD229300362D1802727056C00556769101921F200AC74015960E97EC3F2D03C2430046C0119A3E9A3F95FD3AFE40132CEC52F4017995D9993A90060729EFCA52D3168021223F2236600ECC874E10CC1F9802F3A71C00964EC46E6580402291FE59E0FCF2B4EC31C9C7A6860094B2C4D2E880592F1AD7782992D204A82C954EA5A52E8030064D02A6C1E4EA852FE83D49CB4AE4020CD80272D3B4AA552D3B4AA5B356F77BF1630056C0119FF16C5192901CEDFB77A200E9E65EAC01693C0BCA76FEBE73487CC64DEC804659274A00CDC401F8B51CE3F8803B05217C2E40041A72E2516A663F119AC72250A00F44A98893C453005E57415A00BCD5F1DD66F3448D2600AC66F005246500C9194039C01986B317CDB10890C94BF68E6DF950C0802B09496E8A3600BCB15CA44425279539B089EB7774DDA33642012DA6B1E15B005C0010C8C917A2B880391160944D30074401D845172180803D1AA3045F00042630C5B866200CC2A9A5091C43BBD964D7F5D8914B46F040"));

  print(sumPacketVersions(packets));
}

void partTwo() {
  final packets = parsePacket(convertPacketHexToBinary(
      "E0529D18025800ABCA6996534CB22E4C00FB48E233BAEC947A8AA010CE1249DB51A02CC7DB67EF33D4002AE6ACDC40101CF0449AE4D9E4C071802D400F84BD21CAF3C8F2C35295EF3E0A600848F77893360066C200F476841040401C88908A19B001FD35CCF0B40012992AC81E3B980553659366736653A931018027C87332011E2771FFC3CEEC0630A80126007B0152E2005280186004101060C03C0200DA66006B8018200538012C01F3300660401433801A6007380132DD993100A4DC01AB0803B1FE2343500042E24C338B33F5852C3E002749803B0422EC782004221A41A8CE600EC2F8F11FD0037196CF19A67AA926892D2C643675A0C013C00CC0401F82F1BA168803510E3942E969C389C40193CFD27C32E005F271CE4B95906C151003A7BD229300362D1802727056C00556769101921F200AC74015960E97EC3F2D03C2430046C0119A3E9A3F95FD3AFE40132CEC52F4017995D9993A90060729EFCA52D3168021223F2236600ECC874E10CC1F9802F3A71C00964EC46E6580402291FE59E0FCF2B4EC31C9C7A6860094B2C4D2E880592F1AD7782992D204A82C954EA5A52E8030064D02A6C1E4EA852FE83D49CB4AE4020CD80272D3B4AA552D3B4AA5B356F77BF1630056C0119FF16C5192901CEDFB77A200E9E65EAC01693C0BCA76FEBE73487CC64DEC804659274A00CDC401F8B51CE3F8803B05217C2E40041A72E2516A663F119AC72250A00F44A98893C453005E57415A00BCD5F1DD66F3448D2600AC66F005246500C9194039C01986B317CDB10890C94BF68E6DF950C0802B09496E8A3600BCB15CA44425279539B089EB7774DDA33642012DA6B1E15B005C0010C8C917A2B880391160944D30074401D845172180803D1AA3045F00042630C5B866200CC2A9A5091C43BBD964D7F5D8914B46F040"));

  print(reducePackets(packets));
}

int reducePackets(Packet? packet) {
  if (packet == null) {
    return 0;
  }

  switch (packet.typeId) {
    case 0:
      return packet.subPackets.fold(
        0,
        (sum, subPacket) => sum + reducePackets(subPacket),
      );
    case 1:
      return packet.subPackets.fold(
        1,
        (product, subPacket) => product * reducePackets(subPacket),
      );
    case 2:
      return (packet.subPackets.map((sp) => reducePackets(sp)).toList()..sort())
          .first;
    case 3:
      return (packet.subPackets.map((sp) => reducePackets(sp)).toList()..sort())
          .last;
    case 4:
      return packet.literalValue!;
    case 5:
      final first = packet.subPackets[0];
      final second = packet.subPackets[1];
      if (reducePackets(first) > reducePackets(second)) {
        return 1;
      }
      return 0;
    case 6:
      final first = packet.subPackets[0];
      final second = packet.subPackets[1];
      if (reducePackets(first) < reducePackets(second)) {
        return 1;
      }
      return 0;
    case 7:
      final first = packet.subPackets[0];
      final second = packet.subPackets[1];
      if (reducePackets(first) == reducePackets(second)) {
        return 1;
      }
      return 0;
    default:
      throw Exception();
  }
}

int sumPacketVersions(Packet? packet) {
  if (packet == null) {
    return 0;
  }

  return packet.version +
      packet.subPackets.fold(0, (total, p) => total + sumPacketVersions(p));
}

List<String> convertPacketHexToBinary(String packetInHex) {
  final inputInBinary = packetInHex
      .split('')
      .expand(
        (c) => hexToBinaryMap[c]!.split(''),
      )
      .toList();
  return inputInBinary;
}

Packet? parsePacket(List<String> packetInBinary) {
  if (packetInBinary.isEmpty ||
      packetInBinary.every((element) => element == '0')) {
    return null;
  }

  // 3 bits of version
  final versionBits = packetInBinary.takeAndRemoveN(3);
  final version = decimalFromBinary(versionBits);

  // 3 bits of type id
  final typeIdBits = packetInBinary.takeAndRemoveN(3);
  final typeId = decimalFromBinary(typeIdBits);

  if (typeId == 4) {
    int literalValue = extractLiteralValue(packetInBinary);

    return Packet(
      version: version,
      typeId: typeId,
      literalValue: literalValue,
    );
  } else {
    final packet = Packet(version: version, typeId: typeId, subPackets: []);
    extractOperator(packet, packetInBinary);
    return packet;
  }
}

void extractOperator(Packet packet, List<String> packetInBinary) {
  final lengthTypeIdBit = packetInBinary.takeAndRemoveN(1).first;
  if (lengthTypeIdBit == '0') {
    // the next 15 bits are a number that represents
    // the total length in bits of the sub-packets
    final lengthOfSubpacketsBits = packetInBinary.takeAndRemoveN(15);
    final lengthOfSubpackets = decimalFromBinary(lengthOfSubpacketsBits);
    final subpacketBits = packetInBinary.takeAndRemoveN(lengthOfSubpackets);
    var subPacket = parsePacket(subpacketBits);
    while (subPacket != null) {
      packet.subPackets.add(subPacket);
      subPacket = parsePacket(subpacketBits);
    }
  } else if (lengthTypeIdBit == '1') {
    // the next 11 bits are a number that represents
    // the number of sub-packets in this packet
    final numberOfSubpacketsBits = packetInBinary.takeAndRemoveN(11);
    final numberOfSubpackets = decimalFromBinary(numberOfSubpacketsBits);

    // parse packets until we've parsed the numberOfSubpackets
    for (var i = 0; i < numberOfSubpackets; i++) {
      final subPacket = parsePacket(packetInBinary);
      if (subPacket != null) {
        packet.subPackets.add(subPacket);
      }
    }
  }
}

int extractLiteralValue(List<String> packetInBinary) {
  final literalBits = <String>[];
  List<String> nextBits;
  while (true) {
    nextBits = packetInBinary.takeAndRemoveN(5);
    literalBits.addAll(nextBits.skip(1));
    if (nextBits.first == '0') {
      break;
    }
  }

  final literalValue = decimalFromBinary(literalBits);
  return literalValue;
}

int decimalFromBinary(List<String> binary) {
  var sum = 0;
  for (var i = 0; i < binary.length; i++) {
    final digit = binary[binary.length - 1 - i];
    if (digit == '1') {
      sum += pow(2, i).toInt();
    }
  }
  return sum;
}

class Packet {
  final int version;
  final int typeId;
  final int? literalValue;
  final List<Packet> subPackets;

  Packet({
    required this.version,
    required this.typeId,
    this.literalValue,
    this.subPackets = const [],
  });
}

const hexToBinaryMap = <String, String>{
  '0': '0000',
  '1': '0001',
  '2': '0010',
  '3': '0011',
  '4': '0100',
  '5': '0101',
  '6': '0110',
  '7': '0111',
  '8': '1000',
  '9': '1001',
  'A': '1010',
  'B': '1011',
  'C': '1100',
  'D': '1101',
  'E': '1110',
  'F': '1111',
};

extension on List<String> {
  List<String> takeAndRemoveN(int n) {
    return takeAndRemoveNIterable(n).toList();
  }

  Iterable<String> takeAndRemoveNIterable(int n) sync* {
    while (n > 0) {
      yield removeAt(0);
      n--;
    }
  }
}
