<?php
namespace Modules\Role\Database\factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class RoleFactory extends Factory
{
    protected $model = \Modules\Role\Entities\Role::class;

    public function definition(): array
    {
        return [
            "name" => $this->faker->name(),
        ];
    }
}

