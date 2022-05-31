<?php

namespace Modules\User\Tests\Feature;

use Modules\Core\Tests\BaseTestCase;
use Modules\User\Entities\User;

class UserTest extends BaseTestCase
{
    public function setUp(): void
    {
        $this->model = User::class;

        parent::setUp();
        $this->has_status_test = true;
        $this->user = $this->createAdmin();

        $this->model_name = "User";
        $this->route_prefix = "admin.users";
    }

    public function getCreateData(): array
    {
       return array_merge($this->model::factory()->make()->toArray(), [
            "password" => "password",
            "password_confirmation" => "password"
        ]);
    }

    public function getNonMandotaryCreateData(): array
    {
        $data = array_merge($this->getCreateData());
        unset($data["status"]);
        return $data;
    }

    public function getInvalidCreateData(): array
    {
        return [
            "first_name" => null,
            "last_name" => null,
        ];
    }

    public function testUserShouldBeAbleToRegister()
    {
        $response = $this->withHeaders($this->headers)->post($this->getRoute("register"), $this->getCreateData());
        
        $response->assertCreated();
        $response->assertJsonFragment([
            "status" => "success",
            "message" => $this->lang("register-success")
        ]);
    }
}
