class Items {
  String pageNo, description, btnDescription;
  String image;
  //IconData icon;

  Items({this.pageNo, this.description, this.image, this.btnDescription});
}

class ItemsListBuilder {
  List<Items> itemList =[];

  Items item1 =Items(
      pageNo: 'Acepta un trabajo',
      description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry',
      image: 'assets/image/icon/Layer_4.png',
      btnDescription: 'Skip To App');
  Items item2 =Items(
      pageNo: 'Tracking tiempo real',
      description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industryY',
      image: 'assets/image/icon/Layer_5.png',
      btnDescription: 'Skip To App');
  Items item3 =Items(
      pageNo: 'Gana dinero',
      description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry',
      image: 'assets/image/icon/Layer_3.png',
      btnDescription: 'Continuar a la aplicacion');

  ItemsListBuilder() {
    itemList.add(item1);
    itemList.add(item2);
    itemList.add(item3);
  }
}
