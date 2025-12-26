import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_model.dart';

class EventService {
  final _supabase = Supabase.instance.client;

  // 모든 대회 정보 가져오기
  Future<List<EventModel>> getEvents() async {
    try {
      final response = await _supabase
          .from('events')
          .select()
          .order('event_date', ascending: false);

      return (response as List)
          .map((json) => EventModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  // 특정 대회 정보 가져오기
  Future<EventModel?> getEvent(String id) async {
    try {
      final response = await _supabase
          .from('events')
          .select()
          .eq('id', id)
          .single();

      return EventModel.fromJson(response);
    } catch (e) {
      print('Error fetching event: $e');
      return null;
    }
  }

  // 대회 정보 생성 (관리자만)
  Future<String?> createEvent({
    required String title,
    String? description,
    String? eventUrl,
    String? imageUrl,
    DateTime? eventDate,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return '로그인이 필요합니다';
      }

      await _supabase.from('events').insert({
        'title': title,
        'description': description,
        'event_url': eventUrl,
        'image_url': imageUrl,
        'event_date': eventDate?.toIso8601String(),
        'created_by': userId,
      });

      return null; // 성공
    } catch (e) {
      return e.toString();
    }
  }

  // 대회 정보 수정 (관리자만)
  Future<String?> updateEvent({
    required String id,
    String? title,
    String? description,
    String? eventUrl,
    String? imageUrl,
    DateTime? eventDate,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (eventUrl != null) updates['event_url'] = eventUrl;
      if (imageUrl != null) updates['image_url'] = imageUrl;
      if (eventDate != null) updates['event_date'] = eventDate.toIso8601String();

      await _supabase.from('events').update(updates).eq('id', id);

      return null; // 성공
    } catch (e) {
      return e.toString();
    }
  }

  // 대회 정보 삭제 (관리자만)
  Future<String?> deleteEvent(String id) async {
    try {
      await _supabase.from('events').delete().eq('id', id);
      return null; // 성공
    } catch (e) {
      return e.toString();
    }
  }
}
