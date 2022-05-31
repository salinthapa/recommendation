<?php

namespace Modules\Appointment\Database\factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class AppointmentFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = \Modules\Appointment\Entities\Appointment::class;

    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        return [
            "trainer_id" => 1,
            "customer_id" => 1,
            "appointment_date" => $this->faker->date(),
            "appointment_time" => $this->faker->time(),
            "status" => $this->faker->boolean(),

        ];
    }
}
