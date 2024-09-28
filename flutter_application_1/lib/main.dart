import 'package:flutter/material.dart';
// import 'dart:io'; // Para manipulação de imagens (opcional, se adicionar fotos)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealApp - Gerenciamento de Pacientes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Dashboard(),
    );
  }
}

// Classe do Dashboard (Home)
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> patients = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HealApp Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hello, Hi James",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Cartão do médico
            Card(
              color: Colors.blue.shade100,
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/doctor.jpg'), // Imagem do médico
                  radius: 30,
                ),
                title: Text('Dr. James Baxter'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('General Doctor'),
                    Text('Sunday, 12 June, 11:00 - 12:00 AM'),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            const SizedBox(height: 20),

            // Campo de busca
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Patients or diagnosis',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),

            // Navegação por ícones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.medical_services, color: Colors.blue),
                  onPressed: () {}, // Navegação para CID-10
                ),
                IconButton(
                  icon: const Icon(Icons.people, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PacientesPage(
                          onSavePatient: (newPatient) {
                            setState(() {
                              patients.add(newPatient);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.report, color: Colors.blue),
                  onPressed: () {}, // Navegação para Relatórios
                ),
                IconButton(
                  icon: const Icon(Icons.star, color: Colors.blue),
                  onPressed: () {}, // Navegação para Premium
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Lista de pacientes
            const Text(
              'Pacientes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        patients[index]['name'] ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text('Telefone: ${patients[index]['phone'] ?? ''}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PacientesPage(
                                    patient: patients[index],
                                    onSavePatient: (updatedPatient) {
                                      setState(() {
                                        patients[index] = updatedPatient;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                patients.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue, // Cor de fundo
        selectedItemColor: Colors.blue,
        unselectedItemColor: const Color.fromARGB(179, 160, 160, 160),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Classe da aba Pacientes com funcionalidade de adicionar e editar
class PacientesPage extends StatefulWidget {
  final Map<String, dynamic>? patient;
  final Function(Map<String, dynamic>) onSavePatient;

  const PacientesPage({super.key, this.patient, required this.onSavePatient});

  @override
  _PacientesPageState createState() => _PacientesPageState();
}

class _PacientesPageState extends State<PacientesPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String cpf;
  late String phone;
  late String sex;
  late String woundCondition;

  @override
  void initState() {
    super.initState();
    name = widget.patient?['name'] ?? '';
    cpf = widget.patient?['cpf'] ?? '';
    phone = widget.patient?['phone'] ?? '';
    sex = widget.patient?['sex'] ?? 'Masculino'; // Padrão
    woundCondition = widget.patient?['woundCondition'] ?? '';
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newPatient = {
        'name': name,
        'cpf': cpf,
        'phone': phone,
        'sex': sex,
        'woundCondition': woundCondition,
      };
      widget.onSavePatient(newPatient);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar/Editar Paciente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Nome'),
                onSaved: (value) => name = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor, insira o nome' : null,
              ),
              TextFormField(
                initialValue: cpf,
                decoration: const InputDecoration(labelText: 'CPF'),
                onSaved: (value) => cpf = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor, insira o CPF' : null,
              ),
              TextFormField(
                initialValue: phone,
                decoration: const InputDecoration(labelText: 'Telefone'),
                onSaved: (value) => phone = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor, insira o telefone' : null,
              ),
              const SizedBox(height: 20),

              // Campo para selecionar o sexo
              DropdownButtonFormField<String>(
                value: sex,
                decoration: const InputDecoration(labelText: 'Sexo'),
                items: const [
                  DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                  DropdownMenuItem(value: 'Feminino', child: Text('Feminino')),
                  DropdownMenuItem(value: 'Outro', child: Text('Outro')),
                ],
                onChanged: (value) {
                  setState(() {
                    sex = value!;
                  });
                },
                onSaved: (value) => sex = value!,
              ),
              const SizedBox(height: 20),

              // Campo para a condição da ferida
              TextFormField(
                initialValue: woundCondition,
                decoration: const InputDecoration(labelText: 'Condição da Ferida'),
                onSaved: (value) => woundCondition = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor, insira a condição da ferida' : null,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Salvar Paciente'),
              ),
              const SizedBox(height: 10),

              // Texto dos termos de serviço e política de privacidade
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Ao salvar, você concorda com os Termos de Serviço e a Política de Privacidade.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
