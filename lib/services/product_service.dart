import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class ProductService {
  final _supabase = Supabase.instance.client;

  // 모든 제품 가져오기
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // 특집 제품 가져오기
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .eq('is_featured', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching featured products: $e');
      return [];
    }
  }

  // 제품 생성 (관리자만)
  Future<String?> createProduct({
    required String name,
    String? description,
    String? imageUrl,
    String? productUrl,
    double? price,
    bool isFeatured = false,
  }) async {
    try {
      await _supabase.from('products').insert({
        'name': name,
        'description': description,
        'image_url': imageUrl,
        'product_url': productUrl,
        'price': price,
        'is_featured': isFeatured,
      });

      return null; // 성공
    } catch (e) {
      return e.toString();
    }
  }

  // 제품 수정 (관리자만)
  Future<String?> updateProduct({
    required String id,
    String? name,
    String? description,
    String? imageUrl,
    String? productUrl,
    double? price,
    bool? isFeatured,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (name != null) updates['name'] = name;
      if (description != null) updates['description'] = description;
      if (imageUrl != null) updates['image_url'] = imageUrl;
      if (productUrl != null) updates['product_url'] = productUrl;
      if (price != null) updates['price'] = price;
      if (isFeatured != null) updates['is_featured'] = isFeatured;

      await _supabase.from('products').update(updates).eq('id', id);

      return null; // 성공
    } catch (e) {
      return e.toString();
    }
  }

  // 제품 삭제 (관리자만)
  Future<String?> deleteProduct(String id) async {
    try {
      await _supabase.from('products').delete().eq('id', id);
      return null; // 성공
    } catch (e) {
      return e.toString();
    }
  }
}
