class bar {
  setName(name){
    this.name = name;
    return this;
  }
  setId(id){
    this.id = id;
    return this;
  }
  setAddress(address){
    this.address = address;
    return this;
  }
  setLatitude(latitude){
    this.latitude = latitude;
    return this;
  }
  setLongitude(longitude){
    this.longitude = longitude;
    return this;
  }
  setDescription(description){
    this.description = description;
    return this;
  }
  setOpeningHours(openingHours){
    this.openingHours = openingHours;
    return this;
  }
  setDistance(distance){
    this.distance = distance;
    return this;
  }
  setBarMenu(barMenu){
      this.barMenu = barMenu;
      return this;
  }
  setDeliveryPlaces(deliveryPlaces){
      this.deliveryPlaces = deliveryPlaces;
      return this;
  }
}

module.exports = bar;
