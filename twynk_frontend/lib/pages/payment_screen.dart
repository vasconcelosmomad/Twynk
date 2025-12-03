import 'package:flutter/material.dart';
import 'package:twynk_frontend/portals/app_bar.dart';
import 'package:twynk_frontend/portals/drawer.dart';
import 'package:twynk_frontend/portals/footer.dart';
import 'package:twynk_frontend/pages/encounters.dart';
import 'package:twynk_frontend/pages/ping.dart';
import 'package:twynk_frontend/pages/snaps.dart';
import 'package:twynk_frontend/pages/chat.dart';
import 'package:twynk_frontend/pages/plans.dart';
import 'package:twynk_frontend/services/currency_service.dart';

class PaymentScreen extends StatefulWidget {
  final String initialAmount;

  const PaymentScreen({super.key, required this.initialAmount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String activeTab = 'mpesa';
  String amount = '';
  String amountUsd = '';
  String mpesaPhone = '';
  String status = 'idle';
  String errorMessage = '';

  late final TextEditingController _mpesaAmountController;
  late final TextEditingController _paypalAmountController;

  @override
  void initState() {
    super.initState();
    amount = widget.initialAmount;
    _mpesaAmountController =
        TextEditingController(text: widget.initialAmount);
    _paypalAmountController =
        TextEditingController(text: widget.initialAmount);
    _initPaypalAmount();
  }

  Future<void> _initPaypalAmount() async {
    final mznValue = double.tryParse(widget.initialAmount);
    if (mznValue == null || mznValue <= 0) return;

    try {
      final usd = await converterMZNparaUSD(mznValue);
      if (!mounted || usd == null) return;

      setState(() {
        amountUsd = usd.toStringAsFixed(2);
        _paypalAmountController.text = amountUsd;
      });
    } catch (_) {}
  }

  int _selectedIndex = 4;

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomeYouTubeStyleFlutter()),
      );
      return;
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
      return;
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SnapsPage()),
      );
      return;
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatPage()),
      );
      return;
    }

    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PlansPage()),
      );
      return;
    }
  }

  Future<void> processPayment(String method, Map<String, dynamic> data) async {
    setState(() {
      errorMessage = '';
      status = 'loading';
    });

    await Future.delayed(const Duration(seconds: 2));

    if (method == 'mpesa' && data['mpesaPhone'] == '000000000') {
      throw Exception('Transação M-Pesa falhou. Verifique o número de telefone.');
    }
    if (double.tryParse(data['amount'])! < 1.0) {
      throw Exception('O valor mínimo para transação é 1.00.');
    }
  }

  Future<void> handleMpesaPayment() async {
    if (status == 'loading') return;

    try {
      await processPayment('mpesa', {
        'amount': amount,
        'mpesaPhone': mpesaPhone,
      });
      setState(() => status = 'success');
    } catch (e) {
      setState(() {
        status = 'error';
        errorMessage = e.toString();
      });
    }
  }

  Future<void> handlePaypalPayment() async {
    if (status == 'loading') return;

    if (amountUsd.isEmpty) {
      setState(() {
        status = 'error';
        errorMessage = 'Não foi possível converter o valor para USD.';
      });
      return;
    }

    try {
      await processPayment('paypal', {'amount': amountUsd});
      setState(() => status = 'success');
    } catch (e) {
      setState(() {
        status = 'error';
        errorMessage = e.toString();
      });
    }
  }

  void resetPayment() {
    setState(() {
      amount = widget.initialAmount;
      amountUsd = '';
      mpesaPhone = '';
      status = 'idle';
      errorMessage = '';
      _mpesaAmountController.text = widget.initialAmount;
      _paypalAmountController.text = widget.initialAmount;
    });
    _initPaypalAmount();
  }

  @override
  void dispose() {
    _mpesaAmountController.dispose();
    _paypalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isMobile = MediaQuery.of(context).size.width < 1024;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: NomirroAppBar(
        isMobile: isMobile,
        showCreateAction: false,
        enableSearch: false,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile)
            Container(
              width: 240,
              color: Theme.of(context).cardColor,
              child: SidebarMenu(
                compact: false,
                showDrawerHeader: false,
                selectedIndex: _selectedIndex,
                onItemSelected: _onBottomNavTap,
              ),
            ),
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 40),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: 500,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Processamento de Pagamento',
                            style:
                                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 8),
                          const Text('Selecione o seu método de pagamento preferido.'),

                          const SizedBox(height: 24),

                          // Tabs
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => activeTab = 'mpesa');
                                    resetPayment();
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        'M-Pesa',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: activeTab == 'mpesa'
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        height: 3,
                                        color: activeTab == 'mpesa'
                                            ? Colors.red
                                            : Colors.transparent,
                                        margin: const EdgeInsets.only(top: 6),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => activeTab = 'paypal');
                                    resetPayment();
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        'PayPal',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: activeTab == 'paypal'
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        height: 3,
                                        color: activeTab == 'paypal'
                                            ? Colors.blue
                                            : Colors.transparent,
                                        margin: const EdgeInsets.only(top: 6),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          if (status == 'success')
                            Column(
                              children: [
                                const Icon(Icons.check_circle,
                                    size: 80, color: Colors.green),
                                const Text('Pagamento Concluído!',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: resetPayment,
                                  child: const Text('Novo Pagamento'),
                                )
                              ],
                            )
                          else if (status == 'error')
                            Column(
                              children: [
                                const Icon(Icons.error,
                                    size: 80, color: Colors.red),
                                Text(errorMessage,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: resetPayment,
                                  child: const Text('Tentar Novamente'),
                                )
                              ],
                            )
                          else
                            Column(
                              children: [
                                // M-Pesa form
                                if (activeTab == 'mpesa')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextField(
                                        controller: _mpesaAmountController,
                                        readOnly: true,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(fontSize: 16),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 14),
                                          labelText: 'Valor (MT)',
                                          hintText: 'Ex: 500.00',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: theme
                                                  .colorScheme.primary,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      TextField(
                                        keyboardType: TextInputType.phone,
                                        onChanged: (v) => mpesaPhone = v,
                                        style: const TextStyle(fontSize: 16),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 14),
                                          labelText: 'Número M-Pesa',
                                          hintText: 'Ex: 84xxxxxxx',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: theme
                                                  .colorScheme.primary,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: ElevatedButton(
                                          onPressed: status == 'loading'
                                              ? null
                                              : () => handleMpesaPayment(),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: status == 'loading'
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white)
                                              : const Text('Pagar com M-Pesa'),
                                        ),
                                      )
                                    ],
                                  ),

                                // PayPal form
                                if (activeTab == 'paypal')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextField(
                                        controller: _paypalAmountController,
                                        readOnly: true,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(fontSize: 16),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 14),
                                          labelText: 'Valor (\$)',
                                          hintText: 'Ex: 10.00',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: theme
                                                  .colorScheme.primary,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: ElevatedButton(
                                          onPressed: status == 'loading'
                                              ? null
                                              : () => handlePaypalPayment(),
                                          child: status == 'loading'
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white)
                                              : const Text('Pagar com PayPal'),
                                        ),
                                      ),
                                    ],
                                  ),

                                const SizedBox(height: 16),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: TextButton.icon(
                                    onPressed: () => Navigator.of(context).pop(),
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Voltar'),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? Footer(
              currentIndex: _selectedIndex > 4 ? 0 : _selectedIndex,
              onTap: _onBottomNavTap,
            )
          : null,
    );
  }
}
