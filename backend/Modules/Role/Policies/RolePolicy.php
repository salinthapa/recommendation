<?php

namespace Modules\Role\Policies;

use Illuminate\Auth\Access\HandlesAuthorization;
use Modules\Core\Policies\BasePolicy;

class RolePolicy extends BasePolicy
{
    use HandlesAuthorization;

    public function __construct()
    {
        $this->model_key = "roles";
    }
}
