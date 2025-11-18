<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\User>
 */
class UserFactory extends Factory
{
    /**
     * The current password being used by the factory.
     */
    protected static ?string $password;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'nome' => fake()->name(),
            'genero' => fake()->randomElement(['masculino', 'feminino', 'outro']),
            'interesse' => fake()->randomElement(['masculino', 'feminino', 'ambos']),
            'data_nascimento' => fake()->date('Y-m-d', '-18 years'),
            'email' => fake()->unique()->safeEmail(),
            'password' => static::$password ??= Hash::make('password'),
            'google_id' => null,
            'foto_perfil' => null,
            'bio' => fake()->optional()->sentence(),
            'localizacao' => fake()->optional()->city(),
            'status' => fake()->randomElement(['ativo', 'inativo', 'banido']),
            'plano_id' => null,
        ];
    }
}
