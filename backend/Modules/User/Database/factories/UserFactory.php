<?php

namespace Modules\User\Database\factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;

class UserFactory extends Factory
{
    protected $model = \Modules\User\Entities\User::class;

    public function definition(): array
    {
        return [
            "role_id" => 1,
            "first_name" => $this->faker->firstName(),
            "last_name" => $this->faker->lastName(),
            "email" => $this->faker->unique()->safeEmail(),

            "password" => Hash::make($this->faker->password()),
            "phone" => $this->faker->phoneNumber(),
            "status" => rand(0, 1)
        ];
    }
}
