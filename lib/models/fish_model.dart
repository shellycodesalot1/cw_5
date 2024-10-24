// fish_model.dart

class Fish {
  final double speed;
  final String imageUrl;
  final double size;

  // Constructor with default values
  Fish({
    required this.speed,
    this.imageUrl = "https://www.pngall.com/wp-content/uploads/4/Blue-Fish-PNG-File.png",
    this.size = 50.0, // Default size is 50.0 if not specified
  });
}


