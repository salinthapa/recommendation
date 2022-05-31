<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        $this->call(\Modules\Role\Database\Seeders\RoleDatabaseSeeder::class);
        $this->call(\Modules\User\Database\Seeders\UserDatabaseSeeder::class);
        $this->call(\Modules\Category\Database\Seeders\CategoryDatabaseSeeder::class);
        $this->call(\Modules\Album\Database\Seeders\AlbumDatabaseSeeder::class);
        $this->call(\Modules\Album\Database\Seeders\ImageDatabaseSeeder::class);
        $this->call(\Modules\Article\Database\Seeders\ArticleDatabaseSeeder::class);
        $this->call(\Modules\Comment\Database\Seeders\CommentDatabaseSeeder::class);
    }
}
