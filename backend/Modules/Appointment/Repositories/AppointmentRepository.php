<?php

namespace Modules\Appointment\Repositories;

use Modules\Appointment\Entities\Appointment;
use Modules\Core\Repositories\BaseRepository;

class AppointmentRepository extends BaseRepository
{
    public function __construct(Appointment $appointment)
    {
        $this->model = $appointment;
        $this->model_name = "Appointment";
        $this->model_key = "Appointment";
        $this->rules = [
            "trainer_id" => "required",
            "customer_id" => "required",
            "appointment_time" => "required",
            "appointment_date" => "required",
            "status" => "required",
        ];
    }
}
