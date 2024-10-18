// delete_record.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteRecord {
  Future<void> deleteForm(
    BuildContext context,
    int id,
    List formDetailsList,
    Function refreshList,
  ) async {
    final response = await http.delete(
      Uri.parse('https://localhost:44349/DeleteForm?id=$id'), // Your delete API endpoint
    );

    if (response.statusCode == 200) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Record deleted successfully!')),
      );
      // Remove the item from the list
      formDetailsList.removeWhere((item) => item.id == id);
      // Refresh the list
      refreshList();
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete record.')),
      );
    }
  }
}
