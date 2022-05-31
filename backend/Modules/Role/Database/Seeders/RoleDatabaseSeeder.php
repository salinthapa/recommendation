<?php

namespace Modules\Role\Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Database\Eloquent\Model;

class RoleDatabaseSeeder extends Seeder
{
    public function run(): void
    {
        Model::unguard();

        $this->call(RoleTableSeeder::class);
    }
}
