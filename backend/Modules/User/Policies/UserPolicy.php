<?php

namespace Modules\User\Policies;

use Illuminate\Auth\Access\HandlesAuthorization;
use Modules\Core\Policies\BasePolicy;

class UserPolicy extends BasePolicy
{
    use HandlesAuthorization;

    public function __construct()
    {
        $this->model_key = "users";
    }
}
