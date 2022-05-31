<?php

namespace Modules\User\Tests\Feature;

use Tests\TestCase;
use Illuminate\Support\Str;
use Modules\User\Entities\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Foundation\Testing\DatabaseTransactions;

class SessionTest extends TestCase
{
    use DatabaseTransactions;

    public $password, $user, $route_prefix;
    protected array $headers;

    public function setUp(): void
    {
        parent::setUp();
        $this->user = $this->createAdmin();
        $this->route_prefix = "admin";
    }

    public function createAdmin(): object
    {
        $this->password = Str::random(20);
        $user = User::factory()->create([
            "password" => Hash::make($this->password)
        ]);

        $token = $this->createToken($user->email, $this->password);
        $this->headers = ["Authorization" => "Bearer {$token}", "Accept" => "application/json"];

        return $user;
    }

    public function createToken(string $email, string $password): ?string
    {
        $token = Auth::attempt([
            "email" => $email,
            "password" => $password
        ]);

        return $token ?? null;
    }

    public function getRoute(string $method, array $parameters = []): string
    {
        return route("{$this->route_prefix}.{$method}", $parameters);
    }

    public function lang(string $key): string
    {
        return [
            "login-success" => __("core::response.login-success"),
            "logout-success" => __("core::response.logout-success")
        ][$key] ?? $key;
    }

    public function testAdminCanLoginWithValidCredentials()
    {
        $post_data = [
            "email" => $this->user->email,
            "password" => $this->password
        ];

        $response = $this->post($this->getRoute("login"), $post_data);

        $response->assertOk();
        $response->assertJsonFragment([
            "status" => "success",
            "message" => $this->lang("login-success")
        ]);
    }

    public function testAdminShouldNotBeAbleToLoginWithInvalidCredentials()
    {
        $post_data = [
            "email" => $this->user->email,
            "password" => "INVALID PASSWORD"
        ];

        $response = $this->post($this->getRoute("login"), $post_data);

        $response->assertStatus(422);
        $response->assertJsonFragment([
            "status" => "error"
        ]);
    }

    public function testAdminShouldBeAbleToRetrieveOwnDataWhenLoggedIn()
    {
        $response = $this->withHeaders($this->headers)->get($this->getRoute("me"));

        $response->assertOk();
        $response->assertJsonFragment([
            "status" => "success"
        ]);
    }

    public function testAdminShouldBeAbleToLogout()
    {
        $response = $this->withHeaders($this->headers)->get($this->getRoute("logout"));
        
        $response->assertOk();
        $response->assertJsonFragment([
            "status" => "success",
            "message" => $this->lang("logout-success")
        ]);

        $response = $this->withHeaders($this->headers)->get($this->getRoute("logout"));
        $response->assertStatus(401);
    }
}
