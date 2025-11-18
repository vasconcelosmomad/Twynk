<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Plano;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Criar planos padrão
        $planoGratuito = Plano::create([
            'nome' => 'Gratuito',
            'descricao' => 'Plano básico com acesso limitado',
            'duracao' => 'gratuito',
            'preco' => 0,
            'ativo' => true,
        ]);

        // User::factory(10)->create();

        User::factory()->create([
            'nome' => 'Admin',
            'email' => 'admin@appnamoro.mz',
            'genero' => 'masculino',
            'interesse' => 'feminino',
            'password' => Hash::make('123456'),
        ]);
    }
}
