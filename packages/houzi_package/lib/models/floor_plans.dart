class FloorPlans{
  String? title;
  String? rooms;
  String? bathrooms;
  String? price;
  String? pricePostFix;
  String? size;
  String? image;
  String? description;

  FloorPlans({
    this.title,
    this.rooms,
    this.bathrooms,
    this.price,
    this.pricePostFix,
    this.size,
    this.image,
    this.description
});
}

class FloorPlanElement{
  String? key;
  Map<String, dynamic>? dataMap;

  FloorPlanElement({
    this.key,
    this.dataMap,
  });
}

class AdditionalDetail {
  String? title;
  String? value;

  AdditionalDetail({
    this.title,
    this.value,
  });
}


class MultiUnit {
  String? title;
  String? price;
  String? pricePostfix;
  String? bedrooms;
  String? bathrooms;
  String? size;
  String? sizePostfix;
  String? type;
  String? availabilityDate;

  MultiUnit({
    this.title,
    this.price,
    this.pricePostfix,
    this.bedrooms,
    this.bathrooms,
    this.size,
    this.sizePostfix,
    this.type,
    this.availabilityDate,
  });
}

class Attachment {
  Attachment({
    this.url,
    this.name,
    this.size,
  });

  String? url;
  String? name;
  String? size;
}