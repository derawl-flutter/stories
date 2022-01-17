import 'package:flutter/material.dart';

class Fecth{
  List<Map> stories = [
    {'title': 'Angela',
      'genre': 'Afican folklore',
      'image': 'assets/images/p2.jpg',
      'story': [
        {'title': 'Angela', 'story': 'Once upon a time in a faraway land', 'image': 'assets/images/p2.jpg'},
        {'story': 'There live a man name magarita', 'image': 'assets/images/p1.png'},
        {'story': 'He was tall, fat and had a saggy belly', 'image': 'assets/images/plant.jpg'},
      ]
    },
    {'title': 'Mico',
      'genre': 'Russia tales',
      'image': 'assets/images/p1.png',
      'story':  [
        {'title': 'Mark', 'story': 'Once upon a time in a faraway land', 'image': 'assets/images/p1.png'},
        {'story': 'There live a man name magarita', 'image': 'assets/images/p1.png'},
        {'story': 'He was tall, fat and had a saggy belly', 'image': 'assets/images/plant.jpg'},
      ]
    },
    {'title': 'Mini',
      'genre': 'Asian lore',
      'image': 'assets/images/plant.jpg',
      'story':  [
        {'title': 'The last of the Mohicans', 'story': 'The old', 'image': 'assets/images/plant.jpg'},
        {'story': 'There live a man name magarita', 'image': 'assets/images/p1.png'},
        {'story': 'He was tall, fat and had a saggy belly', 'image': 'assets/images/plant.jpg'},
      ]
    },
    {'title': 'Aloe',
      'genre': 'American tales',
      'image': 'assets/images/p2.jpg',
      'story': [
        {'title': 'Angela', 'story': 'Once upon a time in a faraway land', 'image': 'assets/images/p2.jpg'},
        {'story': 'There live a man name magarita', 'image': 'assets/images/p1.png'},
        {'story': 'He was tall, fat and had a saggy belly', 'image': 'assets/images/plant.jpg'},
      ]
    }

  ];

  List returnProducts(){
    return stories;
  }

}