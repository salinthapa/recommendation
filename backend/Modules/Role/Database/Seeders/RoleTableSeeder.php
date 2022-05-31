<?php

namespace Modules\Role\Database\Seeders;

use Illuminate\Support\Arr;
use Illuminate\Database\Seeder;
use Modules\Role\Entities\Role;
use Illuminate\Database\Eloquent\Model;

class RoleTableSeeder extends Seeder
{
    public function run(): void
    {
        Model::unguard();

        Role::factory()->create([
            "name" => "Admin",
            "permissions" => $this->getPermissions()
        ]);
        Role::factory()->create([
            "name" => "Trainer",
            "permissions" => $this->getPermissions()
        ]);
        Role::factory()->create([
            "name" => "Customer",
            "permissions" => $this->getPermissions()
        ]);
    }

    private function getPermissions(): array
    {
        $models = ["gyms", "roles", "shops", "appointments", "images", "users"];
        $actions = ["index", "show", "store", "update", "destroy"];

        $permissions = array_map(function ($model) use ($actions) {
            return array_map(function ($action) use ($model) {
                return  "{$model}.{$action}";
            }, $actions);
        }, $models);

        return Arr::flatten($permissions);
    }
}
