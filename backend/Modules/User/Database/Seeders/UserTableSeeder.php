<?php

namespace Modules\User\Database\Seeders;

use Illuminate\Database\Seeder;
use Modules\User\Entities\User;
use Illuminate\Database\Eloquent\Model;

class UserTableSeeder extends Seeder
{
    public function run(): void
    {
        Model::unguard();
        User::factory()->create([
            "role_id" => 1,
            "first_name" => "admin",
            "last_name" => "admin",
            "email" => "admin@email.com",
            "qualification" => "not given",
            "password" => bcrypt("admin"),
            "gym_id" => null,
            "phone" => "+1234567",
            "status" => 1
        ]);
    }
}
