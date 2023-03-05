import 'package:supabase_flutter/supabase_flutter.dart';

Future<Supabase> initSupabase() async {
  try {
    return Supabase.instance;
  } catch (e) {
    return Supabase.initialize(
        url: "https://limbadcemvavrnorbkig.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxpbWJhZGNlbXZhdnJub3Jia2lnIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzY5ODYzNTYsImV4cCI6MTk5MjU2MjM1Nn0.RgD8isCOgvIADI9Yv9iifhFi1grpwzZYP-BGIeXXzJM");
  }
}
