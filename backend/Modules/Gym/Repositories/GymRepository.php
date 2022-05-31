<?php

namespace Modules\Gym\Repositories;

use Modules\Gym\Entities\Gym;
use Modules\Core\Repositories\BaseRepository;

class GymRepository extends BaseRepository
{
    public function __construct(Gym $gym)
    {
        $this->model = $gym;
        $this->model_name = "Gym";
        $this->model_key = "gym";
        $this->rules = [
            "name" => "required",
            "contact" => "required",
            "location" => "required",

        ];
    }
}
