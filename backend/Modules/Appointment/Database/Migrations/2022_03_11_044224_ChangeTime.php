<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ChangeTime extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create(
            'appointments',
            function (Blueprint $table) {

                $table->id();

                $table->unsignedBigInteger('trainer_id')->default(null);
                $table->foreign('trainer_id')->references('id')->on('users')->onDelete('cascade');

                $table->unsignedBigInteger('customer_id')->default(null);
                $table->foreign('customer_id')->references('id')->on('users')->onDelete('cascade');
                $table->date('appointment_date')->default(
                    date('Y-m-d')
                );
                $table->string('appointment_time');
                $table->boolean('status')->default(0);

                $table->timestamps();
            }
        );
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('appointments');
    }
}
