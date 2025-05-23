// // lib/screens/budget/create_edit_budget_screen.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:expense_tracker_pro/models/budget.dart';
// import 'package:expense_tracker_pro/services/db_helper.dart';

// class CreateEditBudgetScreen extends StatefulWidget {
//   final String userId;
//   final Budget? budget; // Null for create, non-null for edit

//   const CreateEditBudgetScreen({
//     Key? key,
//     required this.userId,
//     this.budget,
//   }) : super(key: key);

//   @override
//   _CreateEditBudgetScreenState createState() => _CreateEditBudgetScreenState();
// }

// class _CreateEditBudgetScreenState extends State<CreateEditBudgetScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final DBHelper _dbHelper = DBHelper();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
  
//   String _selectedCategory = 'all';
//   String _selectedPeriod = 'monthly';
//   DateTime _startDate = DateTime.now();
//   DateTime _endDate = DateTime.now().add(const Duration(days: 30));
//   bool _isActive = true;
//   bool _isLoading = false;
//   List<String> _categories = ['all', 'food', 'transportation', 'entertainment', 'utilities', 'housing', 'other'];

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//     if (widget.budget != null) {
//       // Edit mode - populate fields
//       _nameController.text = widget.budget!.name;
//       _amountController.text = widget.budget!.amount.toString();
//       _selectedCategory = widget.budget!.category;
//       _selectedPeriod = widget.budget!.period;
//       _startDate = widget.budget!.startDate;
//       _endDate = widget.budget!.endDate;
//       _isActive = widget.budget!.isActive;
//     }
//   }

//   // Future<void> _loadCategories() async {
//   //   // Load transaction categories from the database
//   //   try {
//   //     final cats = await _dbHelper.getDistinctCategories(widget.userId);
//   //     setState(() {
//   //       if (cats.isNotEmpty) {
//   //         _categories = ['all', ...cats];
//   //       }
//   //     });
//   //   } catch (e) {
//   //     // Keep default categories if loading fails
//   //   }
//   // }
//   Future<void> _loadCategories() async {
//   try {
//     final cats = await _dbHelper.getDistinctCategories(widget.userId);
//     setState(() {
//       _categories = ['all', ...cats]; // Always include 'all'
//     });
//   } catch (e) {
//     setState(() {
//       _categories = ['all']; // Ensure 'all' is available even if error
//     });
//   }
// }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _amountController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectStartDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _startDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null && picked != _startDate) {
//       setState(() {
//         _startDate = picked;
//         // Ensure end date is after start date
//         if (_endDate.isBefore(_startDate)) {
//           _endDate = _startDate.add(const Duration(days: 1));
//         }
//       });
//     }
//   }

//   Future<void> _selectEndDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _endDate.isAfter(_startDate) ? _endDate : _startDate.add(const Duration(days: 1)),
//       firstDate: _startDate,
//       lastDate: DateTime(2030),
//     );
//     if (picked != null && picked != _endDate) {
//       setState(() {
//         _endDate = picked;
//       });
//     }
//   }

//   void _setupPeriodDates(String period) {
//     final now = DateTime.now();
    
//     switch (period) {
//       case 'daily':
//         _startDate = DateTime(now.year, now.month, now.day);
//         _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
//         break;
//       case 'weekly':
//         // Start from the beginning of the week (Monday)
//         final weekday = now.weekday;
//         _startDate = now.subtract(Duration(days: weekday - 1));
//         _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day);
//         _endDate = _startDate.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
//         break;
//       case 'monthly':
//         _startDate = DateTime(now.year, now.month, 1);
//         _endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
//         break;
//       case 'yearly':
//         _startDate = DateTime(now.year, 1, 1);
//         _endDate = DateTime(now.year, 12, 31, 23, 59, 59);
//         break;
//       case 'custom':
//         // Keep existing dates for custom
//         break;
//     }
    
//     setState(() {});
//   }

//   Future<void> _saveBudget() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
      
//       try {
//         final name = _nameController.text.trim();
//         final amount = double.parse(_amountController.text);
        
//         final budget = Budget(
//           id: widget.budget?.id, // null for new, existing id for edit
//           userId: widget.userId,
//           name: name,
//           category: _selectedCategory,
//           amount: amount,
//           startDate: _startDate,
//           endDate: _endDate,
//           period: _selectedPeriod,
//           isActive: _isActive,
//         );
        
//         if (widget.budget == null) {
//           // Create mode
//           await _dbHelper.createBudget(budget);
//         } else {
//           // Edit mode
//           await _dbHelper.updateBudget(budget);
//         }
        
//         setState(() => _isLoading = false);
//         Navigator.pop(context, true); // Return success
//       } catch (e) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error saving budget: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEditing = widget.budget != null;
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(isEditing ? 'Edit Budget' : 'Create Budget'),
//       ),
//       body: _isLoading 
//         ? const Center(child: CircularProgressIndicator())
//         : SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Budget Name',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Please enter a name';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
                  
//                   DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(
//                       labelText: 'Category',
//                       border: OutlineInputBorder(),
//                     ),
//                     value: _selectedCategory,
//                     items: _categories.map((String category) {
//                       return DropdownMenuItem<String>(
//                         value: category,
//                         child: Text(category == 'all' ? 'Overall Budget' : category),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedCategory = newValue!;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 16),
                  
//                   TextFormField(
//                     controller: _amountController,
//                     decoration: const InputDecoration(
//                       labelText: 'Budget Amount',
//                       border: OutlineInputBorder(),
//                       prefixText: '\$',
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter an amount';
//                       }
//                       if (double.tryParse(value) == null) {
//                         return 'Please enter a valid number';
//                       }
//                       if (double.parse(value) <= 0) {
//                         return 'Amount must be greater than zero';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
                  
//                   DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(
//                       labelText: 'Budget Period',
//                       border: OutlineInputBorder(),
//                     ),
//                     value: _selectedPeriod,
//                     items: ['daily', 'weekly', 'monthly', 'yearly', 'custom'].map((String period) {
//                       return DropdownMenuItem<String>(
//                         value: period,
//                         child: Text(period.substring(0, 1).toUpperCase() + period.substring(1)),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedPeriod = newValue!;
//                         if (_selectedPeriod != 'custom') {
//                           _setupPeriodDates(_selectedPeriod);
//                         }
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 16),
                  
//                   if (_selectedPeriod == 'custom') ...[
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ListTile(
//                             title: const Text('Start Date'),
//                             subtitle: Text(DateFormat('MMM dd, yyyy').format(_startDate)),
//                             onTap: () => _selectStartDate(context),
//                           ),
//                         ),
//                         Expanded(
//                           child: ListTile(
//                             title: const Text('End Date'),
//                             subtitle: Text(DateFormat('MMM dd, yyyy').format(_endDate)),
//                             onTap: () => _selectEndDate(context),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                   ] else ...[
//                     // Show the calculated dates for preset periods
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Text(
//                         'Period: ${DateFormat('MMM dd, yyyy').format(_startDate)} - ${DateFormat('MMM dd, yyyy').format(_endDate)}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                   ],
                  
//                   SwitchListTile(
//                     title: const Text('Active Budget'),
//                     value: _isActive,
//                     onChanged: (value) {
//                       setState(() {
//                         _isActive = value;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 24),
                  
//                   ElevatedButton(
//                     onPressed: _saveBudget,
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                     ),
//                     child: Text(
//                       isEditing ? 'Update Budget' : 'Create Budget',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//     );
//   }
// }

// // lib/screens/budget/create_edit_budget_screen.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:expense_tracker_pro/models/budget.dart';
// import 'package:expense_tracker_pro/services/db_helper.dart';

// class CreateEditBudgetScreen extends StatefulWidget {
//   final String userId;
//   final Budget? budget; // Null for create, non-null for edit

//   const CreateEditBudgetScreen({
//     Key? key,
//     required this.userId,
//     this.budget,
//   }) : super(key: key);

//   @override
//   _CreateEditBudgetScreenState createState() => _CreateEditBudgetScreenState();
// }

// class _CreateEditBudgetScreenState extends State<CreateEditBudgetScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final DBHelper _dbHelper = DBHelper();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();

//   String _selectedCategory = 'all';
//   String _selectedPeriod = 'monthly';
//   DateTime _startDate = DateTime.now();
//   DateTime _endDate = DateTime.now().add(const Duration(days: 30));
//   bool _isActive = true;
//   bool _isLoading = false;
//   List<String> _categories = ['all', 'food', 'transportation', 'entertainment', 'utilities', 'housing', 'other'];

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//     if (widget.budget != null) {
//       // Edit mode - populate fields
//       _nameController.text = widget.budget!.name;
//       _amountController.text = widget.budget!.amount.toString();
//       _selectedCategory = widget.budget!.category;
//       _selectedPeriod = widget.budget!.period;
//       _startDate = widget.budget!.startDate;
//       _endDate = widget.budget!.endDate;
//       _isActive = widget.budget!.isActive;
//     }
//   }

//   Future<void> _loadCategories() async {
//     try {
//       final cats = await _dbHelper.getDistinctCategories(widget.userId);
//       setState(() {
//         _categories = ['all', ...cats];
//       });
//     } catch (e) {
//       setState(() {
//         _categories = ['all'];
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _amountController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectStartDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _startDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null && picked != _startDate) {
//       setState(() {
//         _startDate = picked;
//         if (_endDate.isBefore(_startDate)) {
//           _endDate = _startDate.add(const Duration(days: 1));
//         }
//       });
//     }
//   }

//   Future<void> _selectEndDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _endDate.isAfter(_startDate) ? _endDate : _startDate.add(const Duration(days: 1)),
//       firstDate: _startDate,
//       lastDate: DateTime(2030),
//     );
//     if (picked != null && picked != _endDate) {
//       setState(() {
//         _endDate = picked;
//       });
//     }
//   }

//   void _setupPeriodDates(String period) {
//     final now = DateTime.now();

//     switch (period) {
//       case 'daily':
//         _startDate = DateTime(now.year, now.month, now.day);
//         _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
//         break;
//       case 'weekly':
//         final weekday = now.weekday;
//         _startDate = now.subtract(Duration(days: weekday - 1));
//         _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day);
//         _endDate = _startDate.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
//         break;
//       case 'monthly':
//         _startDate = DateTime(now.year, now.month, 1);
//         _endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
//         break;
//       case 'yearly':
//         _startDate = DateTime(now.year, 1, 1);
//         _endDate = DateTime(now.year, 12, 31, 23, 59, 59);
//         break;
//       case 'custom':
//         break;
//     }

//     setState(() {});
//   }

//   Future<void> _saveBudget() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);

//       try {
//         final name = _nameController.text.trim();
//         final amount = double.parse(_amountController.text);

//         final budget = Budget(
//           id: widget.budget?.id,
//           userId: widget.userId,
//           name: name,
//           category: _selectedCategory,
//           amount: amount,
//           startDate: _startDate,
//           endDate: _endDate,
//           period: _selectedPeriod,
//           isActive: _isActive,
//         );

//         if (widget.budget == null) {
//           await _dbHelper.createBudget(budget);
//         } else {
//           await _dbHelper.updateBudget(budget);
//         }

//         setState(() => _isLoading = false);
//         Navigator.pop(context, true);
//       } catch (e) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error saving budget: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEditing = widget.budget != null;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(isEditing ? 'Edit Budget' : 'Create Budget'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: const InputDecoration(
//                         labelText: 'Budget Name',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter a name';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     DropdownButtonFormField<String>(
//                       decoration: const InputDecoration(
//                         labelText: 'Category',
//                         border: OutlineInputBorder(),
//                       ),
//                       value: _selectedCategory,
//                       items: _categories.map((String category) {
//                         return DropdownMenuItem<String>(
//                           value: category,
//                           child: Text(category == 'all' ? 'Overall Budget' : category),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           _selectedCategory = newValue!;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     TextFormField(
//                       controller: _amountController,
//                       decoration: const InputDecoration(
//                         labelText: 'Budget Amount',
//                         border: OutlineInputBorder(),
//                         prefixText: '\$',
//                       ),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter an amount';
//                         }
//                         if (double.tryParse(value) == null) {
//                           return 'Please enter a valid number';
//                         }
//                         if (double.parse(value) <= 0) {
//                           return 'Amount must be greater than zero';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     DropdownButtonFormField<String>(
//                       decoration: const InputDecoration(
//                         labelText: 'Budget Period',
//                         border: OutlineInputBorder(),
//                       ),
//                       value: _selectedPeriod,
//                       items: ['daily', 'weekly', 'monthly', 'yearly', 'custom'].map((String period) {
//                         return DropdownMenuItem<String>(
//                           value: period,
//                           child: Text(period[0].toUpperCase() + period.substring(1)),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           _selectedPeriod = newValue!;
//                           if (_selectedPeriod != 'custom') {
//                             _setupPeriodDates(_selectedPeriod);
//                           }
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     if (_selectedPeriod == 'custom') ...[
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ListTile(
//                               title: const Text('Start Date'),
//                               subtitle: Text(DateFormat('MMM dd, yyyy').format(_startDate)),
//                               onTap: () => _selectStartDate(context),
//                             ),
//                           ),
//                           Expanded(
//                             child: ListTile(
//                               title: const Text('End Date'),
//                               subtitle: Text(DateFormat('MMM dd, yyyy').format(_endDate)),
//                               onTap: () => _selectEndDate(context),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                     ] else ...[
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: Text(
//                           'Period: ${DateFormat('MMM dd, yyyy').format(_startDate)} - ${DateFormat('MMM dd, yyyy').format(_endDate)}',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                     ],

//                     SwitchListTile(
//                       title: const Text('Active Budget'),
//                       value: _isActive,
//                       onChanged: (value) {
//                         setState(() {
//                           _isActive = value;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 20),

//                     ElevatedButton(
//                       onPressed: _saveBudget,
//                       child: Text(isEditing ? 'Update Budget' : 'Create Budget'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
// lib/screens/budget/create_edit_budget_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker_pro/models/budget.dart';
import 'package:expense_tracker_pro/services/db_helper.dart';

class CreateEditBudgetScreen extends StatefulWidget {
  final String userId;
  final Budget? budget; // Null for create, non-null for edit

  const CreateEditBudgetScreen({
    Key? key,
    required this.userId,
    this.budget,
  }) : super(key: key);

  @override
  _CreateEditBudgetScreenState createState() => _CreateEditBudgetScreenState();
}

class _CreateEditBudgetScreenState extends State<CreateEditBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final DBHelper _dbHelper = DBHelper();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String _selectedCategory = 'all';
  String _selectedPeriod = 'monthly';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  bool _isActive = true;
  bool _isLoading = false;
  List<String> _categories = [
    'all', 
    'Groceries', 
    'Utilities', 
    'Entertainment', 
    'Transport', 
    'Bills', 
    'Healthcare', 
    'Shopping', 
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.budget != null) {
      // Edit mode - populate fields
      _nameController.text = widget.budget!.name;
      _amountController.text = widget.budget!.amount.toString();
      _selectedCategory = widget.budget!.category;
      _selectedPeriod = widget.budget!.period;
      _startDate = widget.budget!.startDate;
      _endDate = widget.budget!.endDate;
      _isActive = widget.budget!.isActive;
    }
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await _dbHelper.getDistinctCategories(widget.userId);
      setState(() {
        // Combine default categories with user's existing categories
        final allCategories = {
          'all',
          'Groceries', 
          'Utilities', 
          'Entertainment', 
          'Transport', 
          'Bills', 
          'Healthcare', 
          'Shopping', 
          'Other',
          ...cats
        };
        _categories = allCategories.toList();
      });
    } catch (e) {
      setState(() {
        _categories = [
          'all', 
          'Groceries', 
          'Utilities', 
          'Entertainment', 
          'Transport', 
          'Bills', 
          'Healthcare', 
          'Shopping', 
          'Other'
        ];
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate.isAfter(_startDate) ? _endDate : _startDate.add(const Duration(days: 1)),
      firstDate: _startDate,
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _setupPeriodDates(String period) {
    final now = DateTime.now();

    switch (period) {
      case 'daily':
        _startDate = DateTime(now.year, now.month, now.day);
        _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'weekly':
        final weekday = now.weekday;
        _startDate = now.subtract(Duration(days: weekday - 1));
        _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day);
        _endDate = _startDate.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
        break;
      case 'monthly':
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case 'yearly':
        _startDate = DateTime(now.year, 1, 1);
        _endDate = DateTime(now.year, 12, 31, 23, 59, 59);
        break;
      case 'custom':
        break;
    }

    setState(() {});
  }

  Future<void> _saveBudget() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final name = _nameController.text.trim();
        final amount = double.parse(_amountController.text);

        final budget = Budget(
          id: widget.budget?.id,
          userId: widget.userId,
          name: name,
          category: _selectedCategory,
          amount: amount,
          // ✅ Initialize remaining amount properly
          remaining: widget.budget?.remaining ?? amount, // Use existing remaining or full amount for new budget
          startDate: _startDate,
          endDate: _endDate,
          period: _selectedPeriod,
          isActive: _isActive,
        );

        if (widget.budget == null) {
          await _dbHelper.createBudget(budget);
        } else {
          await _dbHelper.updateBudget(budget);
        }

        setState(() => _isLoading = false);
        Navigator.pop(context, true);
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving budget: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.budget != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Budget' : 'Create Budget'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Budget Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.label),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      value: _selectedCategory,
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category == 'all' ? 'Overall Budget' : category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Budget Amount (RWF)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.monetization_on),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Amount must be greater than zero';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ✅ Show remaining amount for existing budgets
                    if (widget.budget != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.account_balance_wallet, color: Colors.blue.shade700),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Remaining Budget',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'RWF ${NumberFormat('#,##0.00').format(widget.budget!.remaining)}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Budget Period',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_month),
                      ),
                      value: _selectedPeriod,
                      items: ['daily', 'weekly', 'monthly', 'yearly', 'custom'].map((String period) {
                        return DropdownMenuItem<String>(
                          value: period,
                          child: Text(period[0].toUpperCase() + period.substring(1)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPeriod = newValue!;
                          if (_selectedPeriod != 'custom') {
                            _setupPeriodDates(_selectedPeriod);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    if (_selectedPeriod == 'custom') ...[
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectStartDate(context),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Start Date',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('MMM dd, yyyy').format(_startDate),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectEndDate(context),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'End Date',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('MMM dd, yyyy').format(_endDate),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.date_range, color: Colors.grey),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Budget Period',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${DateFormat('MMM dd, yyyy').format(_startDate)} - ${DateFormat('MMM dd, yyyy').format(_endDate)}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    SwitchListTile(
                      title: const Text('Active Budget'),
                      subtitle: Text(_isActive ? 'This budget is active' : 'This budget is inactive'),
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      onPressed: _saveBudget,
                      icon: Icon(isEditing ? Icons.update : Icons.save),
                      label: Text(isEditing ? 'Update Budget' : 'Create Budget'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}