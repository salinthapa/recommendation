<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class MakeMakeUser extends Migration
{
    public function up(): void
    {
        Schema::create("users", function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger("role_id");
            $table->foreign("role_id")->references("id")->on("roles")->onDelete("restrict");
            $table->string("first_name");
            $table->string("last_name");
            $table->string("qualification");
            $table->unsignedBigInteger("gym_id")->nullable();
            $table->foreign("gym_id")->references("id")->on("gyms")->onDelete("set null");
            $table->string("email")->unique();
            $table->string("password");
            $table->string("phone")->unique();
            $table->boolean("status")->default(1);
            $table->timestamp("email_verified_at")->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists("users");
    }
}
