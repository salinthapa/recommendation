<?php

namespace Modules\Role\Tests\Feature;

use Modules\Core\Tests\BaseTestCase;
use Modules\Role\Entities\Role;

class RoleTest extends BaseTestCase
{
    public function setUp(): void
    {
        $this->model = Role::class;
        $this->model_name = "Role";
        $this->route_prefix = "roles";

        parent::setUp();
        $this->default_resource_id = $this->model::factory()->create()->id;
    }

    public function getInvalidCreateData(): array
    {
        return [
            "name" => null,
            "permissions" => "Not an array"
        ];
    }
}
