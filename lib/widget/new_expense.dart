import 'package:flutter/material.dart';
import 'package:expense_tracker/model/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _textController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final _enteredAmount = double.tryParse(_amountController
        .text); //tryParse('Hello')=>null , tryParse('1,12')=> 1,12
    final amountIsValid = _enteredAmount == null || _enteredAmount <= 0;
    if (_textController.text.trim().isEmpty ||
        amountIsValid ||
        _selectedDate == null) {
      // show wrror message
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'please make sure a valid title , amount , date and category was entered .'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay')),
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(Expense(
      title: _textController.text,
      amount: _enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    ));
    Navigator.pop(context);
  }


  @override
  void dispose() {
    _textController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom; 

    return LayoutBuilder(builder: (ctx, constraints) {
      return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(16 , 48 , 16 , keyboardSpace + 16),
          child: Column(
            children: [
              //for title
              TextField(
                controller: _textController,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      //for amount
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        label: Text('Amount'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_selectedDate == null
                            ? 'No date selected'
                            : formatter.format(_selectedDate!)),
                        IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_month)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                category.name.toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      }),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  ElevatedButton(
                    onPressed: () {
                      _submitExpenseData();
                    },
                    child: const Text('Save expense'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
      
    },) ;

  
  }
}
