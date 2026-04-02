class ListData {
  static List userLog = [];

  static List service_list = [
    {
      "name": "Generate QR",
      "image":
          "https://www.cnet.com/a/img/resize/f79daa2916d5016c0eae39d9f011fb45c286384a/hub/2021/09/29/84563ecd-e228-4ac2-826d-41c5478ce588/cnet-qr-code.jpg?auto=webp&width=1200",
    },
    {
      "name": "Scan QR",
      "image":
          "https://helpdeskgeek.com/wp-content/pictures/2021/03/scan-qr-code.jpg",
    },
    // {
    //   "name": "Delivery",
    //   "image": "https://static.vecteezy.com/system/resources/previews/001/977/437/original/delivery-workers-with-face-masks-and-motorcycle-free-vector.jpg"
    // }
  ];

  // list for country
  static List countryList = [
    {
      "id": 1,
      "name": "Nepal",
      "flag": "assets/flag/flag_np.png",
      "country_code": "+977",
    },
    {
      "id": 2,
      "name": "India",
      "flag": "assets/flag/flag_in.png",
      "country_code": "+91",
    },
    {
      "id": 3,
      "name": "Bangladesh",
      "flag": "assets/flag/flag_bg.png",
      "country_code": "+880",
    },
  ];

  // service list
  static List serviceList = [
    {"id": 1, "name": "Bike", "image": "assets/icons/ic_bike.png"},
    {"id": 2, "name": "Car", "image": "assets/icons/ic_car.png"},
    {"id": 3, "name": "Food", "image": "assets/icons/ic_food.png"},
    {"id": 4, "name": "Car Pool", "image": "assets/icons/ic_pool.png"},
    {"id": 5, "name": "Delivery", "image": "assets/icons/ic_bike_tile.png"},
    {"id": 6, "name": "Rental", "image": "assets/icons/ic_rental.png"},
  ];

  // whats new menu
  static List whatsNewList = [
    {"id": 1, "view": "All"},
    {"id": 2, "view": "Notice"},
    {"id": 3, "view": "Trending"},
    {"id": 4, "view": "Food"},
    {"id": 5, "view": "Promotion"},
    {"id": 6, "view": "Banner"},
  ];

  // slider image list
  static List sliderList = [
    "https://pathao.com/np/wp-content/uploads/sites/7/2021/11/banner-2-2-348x224.jpg",
    "https://pathao.com/np/wp-content/uploads/sites/7/2021/12/PR-Banner-348x224.png",
    "https://pathao.com/np/wp-content/uploads/sites/7/2019/09/Pathao-Nepal-Ridesharing-Nepal-348x224.jpg",
  ];

  // food slider
  static List foodSliderList = [
    "https://cdn.dribbble.com/users/1520130/screenshots/11008333/hb_4x.jpg",
    "https://cdn.dribbble.com/users/5739021/screenshots/15406330/media/4ea23eadcb0fadfb18d52c5dada5df7c.jpg",
    "https://files.muzli.space/c74c71bc9c28afe864377212fcdb60b5.jpeg",
  ];

  // favorite cousin
  static List cousinList = [
    {
      "name": "Burgers",
      "image":
          "https://media.globalcitizen.org/thumbnails/dd/86/dd864bf1-07c5-43b7-b247-0ef09f8c6ce6/likemeat-73_oba0ib_0-unsplash.jpg__1600x900_q85_crop_subsampling-2.jpg",
    },
    {
      "name": "Biryani",
      "image":
          "https://media.istockphoto.com/photos/biryani-picture-id1305452646?b=1&k=20&m=1305452646&s=170667a&w=0&h=1M4qIQor9-oTbDFc8osB9TKQEEMBn7j_4D1Qy7hRdNk=",
    },
    {
      "name": "Desserts",
      "image": "https://static.toiimg.com/photo/75508582.cms",
    },
    {
      "name": "Chinese",
      "image":
          "https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/02/07/15/chinese.jpg?width=1200",
    },
    {
      "name": "Bakery",
      "image":
          "https://www.mashed.com/img/gallery/the-best-bakery-in-every-state/intro-1601499029.jpg",
    },
    {
      "name": "Fast Food",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSttVVN5Nt3HOlnGesfLjJAdgbu7kH6ZcLpJw&usqp=CAU",
    },
    {
      "name": "Coffee",
      "image":
          "https://c4.wallpaperflare.com/wallpaper/231/256/948/coffee-bean-cup-still-life-photography-coffee-cup-wallpaper-preview.jpg",
    },
  ];

  static List foodList = [
    {
      "id": 1,
      "image":
          "https://foodmandu.com//Images/Vendor/1164/Logo/Web_250321094558.listing.jpg",
      "name": "Alphabeat Restaurant",
      "tag": "American Food",
      "rating": 3.7,
      "review_no": 147,
      "delivery_amt": 150,
    },
    {
      "id": 2,
      "image":
          "https://fmdadmin.foodmandu.com//Images/Vendor/893/Logo/WhatsApp_Image_2021-12-08_at_12_081221062143.04.59_PM.jpeg",
      "name": "80's Cave Cafe & Restaurant",
      "tag": "Classic Food",
      "rating": 4.2,
      "review_no": 117,
      "delivery_amt": 120,
    },
    {
      "id": 3,
      "image":
          "https://foodmandu.com//Images/Vendor/1164/Logo/Web_250321094558.listing.jpg",
      "name": "Alphabeat Restaurant",
      "tag": "American Food",
      "rating": 3.7,
      "review_no": 147,
      "delivery_amt": 150,
    },
    {
      "id": 4,
      "image":
          "https://fmdadmin.foodmandu.com//Images/Vendor/893/Logo/WhatsApp_Image_2021-12-08_at_12_081221062143.04.59_PM.jpeg",
      "name": "80's Cave Cafe & Restaurant",
      "tag": "Classic Food",
      "rating": 4.2,
      "review_no": 117,
      "delivery_amt": 120,
    },
  ];

  // filter by
  static List filterBy = [
    {"content": "Currently Open Restaurants", "status": false},
    {"content": "Restaurants offering Discounts", "status": false},
  ];

  // filter by price
  static List filterByPrice = [
    {"content": "Price from Low - High", "status": false},
    {"content": "Price from High - Low", "status": false},
  ];

  // menu list
  static List menu = [
    {"id": 1, "name": "Today's Request", "status": 1},
    {"id": 1, "name": "Delivery History", "status": 0},
  ];
  // menu list
  static List qrMenu = [
    {"id": 1, "name": "Scan", "status": 1},
    {"id": 2, "name": "My QR", "status": 0},
  ];

  // pool request
  static List poolReuest = [
    {
      "id": 1,
      "datetime": "23 JAN 2022, 10:21 AM",
      "pick_up": "Koteshwor, Kathmandu",
      "drop_out": "Bhadhrapur New Road, Jhapa",
      "cost": "Rs.799",
    },
    {
      "id": 1,
      "datetime": "25 FEB 2022, 12:10 PM",
      "pick_up": "Kalopani Shankhmul, Kathmandu",
      "drop_out": "Brihaspatimarga, New youth club , Birgunj",
      "cost": "Rs.755",
    },
    {
      "id": 1,
      "datetime": "23 JAN 2022, 10:21 AM",
      "pick_up": "Raginichok Balkot Bhaktapur",
      "drop_out": "Doleshwor Mahadev, Banepa",
      "cost": "Rs.490",
    },
  ];

  // ride request
  static List rideReuest = [
    {
      "id": 1,
      "datetime": "23 JAN 2022, 10:21 AM",
      "pick_up": "Raginichok Balkot Bhaktapur",
      "drop_out": "Kshitiz Bakery and Bhojanalaya, Subidha marga",
      "cost": "Rs.96",
    },
    {
      "id": 1,
      "datetime": "25 FEB 2022, 12:10 PM",
      "pick_up": "Kalopani Shankhmul, Kathmandu",
      "drop_out": "Brihaspatimarga, New youth club , Balkot",
      "cost": "Rs.125",
    },
    {
      "id": 1,
      "datetime": "23 JAN 2022, 10:21 AM",
      "pick_up": "Raginichok Balkot Bhaktapur",
      "drop_out": "Kshitiz Bakery and Bhojanalaya, Subidha marga",
      "cost": "Rs.96",
    },
    {
      "id": 1,
      "datetime": "25 FEB 2022, 12:10 PM",
      "pick_up": "Kalopani Shankhmul, Kathmandu",
      "drop_out": "Brihaspatimarga, New youth club , Balkot",
      "cost": "Rs.125",
    },
  ];

  // campaign and notification
  static List campaign = [
    {
      "image": "https://i.ytimg.com/vi/3MvRaEXY74k/maxresdefault.jpg",
      "title": "Know How to apply food promo codes",
      "content":
          "Want a discount on a food? Watch this video to know how to apply promo codes.",
    },
    {
      "image": "https://i.imgur.com/UCKN3A2.jpg",
      "title": "How to order food with Pathao",
      "content":
          "Carving some delicious yummies? Watch this video to learn how to apply promo code and order food.",
    },
    {
      "image": "https://i.ytimg.com/vi/3MvRaEXY74k/maxresdefault.jpg",
      "title": "Know How to apply food promo codes",
      "content":
          "Want a discount on a food? Watch this video to know how to apply promo codes.",
    },
    {
      "image": "https://i.imgur.com/UCKN3A2.jpg",
      "title": "How to order food with Pathao",
      "content":
          "Carving some delicious yummies? Watch this video to learn how to apply promo code and order food.",
    },
  ];

  // notification
  static List notification = [
    {
      "icon": "Icons.card_giftcard_rounded",
      "content":
          "Friday call for making memories not counting calories. Order using promocode KHALTITURN75 to get a"
          "flat Rs. 175 off on your order. Enjoy! ",
      "datetime": "Jan 28, 11:45 AM",
    },
  ];

  // cancel reason
  static List cancel = [
    {"id": 1, "reason": ""},
  ];

  // covid instruction
  List covidInfo = [
    {
      "image": "assets/icons/ic_cashless_payment.png",
      "content": "Use Digital Payment to avoid contact with notes & coins.",
    },
    {
      "image": "assets/icons/ic_cashless_payment.png",
      "content": "Use Digital Payment to avoid contact with notes & coins.",
    },
  ];
}
