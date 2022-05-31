<?php

namespace Modules\Gym\Policies;

use Illuminate\Auth\Access\HandlesAuthorization;
use Modules\Core\Policies\BasePolicy;

class GymPolicy extends BasePolicy
{
    use HandlesAuthorization;

    public function __construct()
    {
        $this->model_key = "gyms";
    }
}