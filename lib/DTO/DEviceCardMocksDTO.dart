import 'package:ass/WIdgets/DeviceListItem.dart';

class DeviceCardMockDTO{

    static List<DeviceListItem> generateCards(){

      String title1 = "Kaffeemaschine SEACO";
      String imgUrl1 = "http://pngimg.com/uploads/coffee_machine/coffee_machine_PNG17259.png";

      String title2 = "Waschmaschine";
      String imgUrl2 = "https://www.pngmart.com/files/6/Washing-Machine-PNG-Pic.png";

      String title3 = "Der Gerät";
      String imgUrl3 = "https://media.istockphoto.com/photos/kebab-picture-id92189411?k=20&m=92189411&s=612x612&w=0&h=mLL4cWXzSzBV7F0ZhNMI41DE3T8AddNdBSqH0Yi5rjs=";

       String title4 = "Fernseher Samsung";
      String imgUrl4 = "https://pngimg.com/uploads/tv/tv_PNG39240.png";
      List<DeviceListItem> items = [];

      items.add( DeviceListItem(title: "", imgUrl: ""));              
      items.add(DeviceListItem(title: title1, imgUrl: imgUrl1));
      items.add(DeviceListItem(title: title2, imgUrl: imgUrl2));
      items.add(DeviceListItem(title: title3, imgUrl: imgUrl3));
      items.add(DeviceListItem(title: title4, imgUrl: imgUrl4));

      return items;

    }
}
