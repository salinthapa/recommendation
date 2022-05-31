<?php

namespace Modules\Role\Repositories;

use Modules\Role\Entities\Role;
use Modules\Core\Repositories\BaseRepository;

class RoleRepository extends BaseRepository
{
    public function __construct(Role $role)
    {
        $this->model = $role;
        $this->model_name = "Role";
        $this->model_key = "role";
        $this->rules = [
            "name" => "required",
            "permissions" => "sometimes|nullable|array"
        ];
    }
}
