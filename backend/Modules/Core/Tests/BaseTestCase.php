<?php

namespace Modules\Core\Tests;

use Tests\TestCase;
use Illuminate\Support\Str;
use Modules\User\Entities\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Illuminate\Support\Facades\Hash;

class BaseTestCase extends TestCase
{
    use DatabaseTransactions;

    protected array $headers;

    public $model, $model_name, $route_prefix, $filters, $default_resource_id, $fake_resource_id, $factory_count;
    public $create_factories, $has_filters, $has_index_test, $has_show_test, $has_store_test, $has_update_test, $has_destroy_test;
    
    public function setUp(): void
    {
        parent::setUp();

        $this->factory_count = 2;
        $this->default_resource_id = $this->model::latest("id")->first()->id;
        $this->fake_resource_id = 0;
        $this->filters = [
            "limit" => 25,
            "sort_by" => "id",
            "sort_order" => "asc"
        ];

        $this->create_factories = true;
        $this->has_filters = true;
        $this->has_index_test = true;
        $this->has_show_test = true;
        $this->has_update_test = true;
        $this->has_destroy_test = true;
        $this->has_store_test = true;
        $this->has_status_test = false;
        $this->createAdmin();
    }

    /**
     * Helper methods
     */

    public function createAdmin(array $attributes = []): object
    {
        $attributes = array_merge([
            "password" => "password"
        ], $attributes);

        $data = [
            "password" => Hash::make($attributes["password"])
        ];

        $user = User::factory()->create($data);

        $token = $this->createToken($user->email, $attributes["password"]);
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
            "fetch-all-success" => __("core::response.fetch-success", ["name" => Str::plural($this->model_name)]),
            "fetch-success" => __("core::response.fetch-success", ["name" => $this->model_name]),
            "store-success" => __("core::response.store-success", ["name" => $this->model_name]),
            "update-success" => __("core::response.update-success", ["name" => $this->model_name]),
            "delete-success" => __("core::response.delete-success", ["name" => $this->model_name]),
            "status-success" => __("core::response.status-success", ["name" => $this->model_name]),
            "assign-success" => __("core::response.assign-success", ["name" => $this->model_name]),

            "not-found" => __("core::response.not-found", ["name" => $this->model_name]),
            "register-success" => __("core::response.register-success", ["name" => $this->model_name])
        ][$key] ?? $key;
    }

    public function getCreateData(): array { return $this->model::factory()->make()->toArray(); }
    public function getNonMandotaryCreateData(): array { return $this->getCreateData(); }
    public function getInvalidCreateData(): array { return []; }
    public function getUpdateData(): array { return $this->getCreateData(); }
    public function getNonMandotaryUpdateData(): array { return $this->getNonMandotaryCreateData(); }
    public function getInvalidUpdateData(): array { return $this->getInvalidCreateData(); }

    /**
     * GET method tests
     * 
     * 1. Assert if resource list can be fetched.
     * 2. Assert if resource list can be fetched with filters.
     * 3. Assert if individual resource can be fetched.
     * 4. Assert if the application returns error for invalid resource id.
     */

    public function testAdminCanFetchResources(): void 
    {
        $this->createAdmin();
        if ( !$this->has_index_test ) $this->markTestSkipped("Index method not available.");
        if ( $this->create_factories ) $this->model::factory($this->factory_count)->create();

        $response = $this->withHeaders($this->headers)->get($this->getRoute("index"));

        $response->assertOk();
        $response->assertJsonFragment([
            "status" => "success",
            "message" => $this->lang("fetch-all-success")
        ]);
    }

    public function testAdminCanFetchResourcesWithFilters()
    {
        $this->createAdmin();
        if ( !$this->has_index_test ) $this->markTestSkipped("Index method not available.");
        if ( !$this->has_filters ) $this->markTestSkipped("Filters not available.");

        $response = $this->withHeaders($this->headers)->get($this->getRoute("index", $this->filters));

        $response->assertOk();
        $response->assertJsonFragment([
            "status" => "success",
            "message" => $this->lang("fetch-all-success")
        ]);
    }

    public function testAdminCanFetchIndividualResource(): void
    {
        if ( !$this->has_show_test ) $this->markTestSkipped("Show method not available.");

        $response = $this->withHeaders($this->headers)->get($this->getRoute("show", [$this->default_resource_id]));

        $response->assertOk();
        $response->assertJsonFragment([
            "status" => "success",
            "message" => $this->lang("fetch-success")
        ]);
    }

    public function testShouldReturnErrorForInvalidResourceId()
    {
        if ( !$this->has_show_test ) $this->markTestSkipped("Show method not available.");

        $response = $this->withHeaders($this->headers)->get($this->getRoute("show", [$this->fake_resource_id]));
        
        $response->assertNotFound();
        $response->assertJsonFragment([
            "status" => "error",
            "message" => $this->lang("not-found")
        ]);
    }

    /**
     * POST method tests
     * 
     * 1. Assert if resource can be created.
     * 2. Assert if resource can be created with non-mandotary data.
     * 3. Assert if the application returns error when invaid data is provided.
     */

    public function testAdminCanCreateResource(): void
    {
        if ( !$this->has_store_test ) $this->markTestSkipped("Store method not available."); 
        $response = $this->withHeaders($this->headers)->post($this->getRoute("store"), $this->getCreateData());

        $response->assertCreated();
        $response->assertJsonFragment([
            "status" => "success",
            "message" => $this->lang("store-success")
        ]);
    }

    public function testAdminCanCreateWithNonMandatoryData(): void
    {
        $response = $this->withHeaders($this->headers)->post($this->getRoute("store"), $this->getNonMandotaryCreateData());

        $response->assertCreated();
        $response->assertJsonFragment([
            "status" => "success",
            "message" => $this->lang("store-success")
        ]);
    }

    public function testAdminCanCreateWithInvalidData(): void
    {
        $response = $this->withHeaders($this->headers)->post($this->getRoute("store"), $this->getInvalidCreateData());

        $response->assertStatus(422);
        $response->assertJsonFragment([
            "status" => "error"
        ]);
    }

    /**
     * PUT method tests
     * 
     * 1. Assert if resource can be updated.
     * 2. Assert if resource can be updated with non-mandotary data.
     * 3. Assert if the application returns error when invaid data is provided.
     * 4. Assert if the application returns error when trying to update invalid resource.
    */

    public function testAdminCanUpdateResources(): void
    {
        $response = $this->withHeaders($this->headers)->put($this->getRoute("update", [$this->default_resource_id]), $this->getUpdateData());

        $response->assertOk();
        $response->assertJsonFragment([
            "status" => "success",
            "message" => $this->lang("update-success")
        ]);
    }

    public function testAdminCanUpdateResourceWithNonMandatoryData(): void
    {
        $response = $this->withHeaders($this->headers)->put($this->getRoute("update", [$this->default_resource_id]), $this->getNonMandotaryUpdateData());

        $response->assertOk();
        $response->assertJsonFragment([
            "status" => "success",
            "message" => $this->lang("update-success")
        ]);
    }

    public function testShouldReturnErrorIfUpdatedWithInvalidData(): void
    {
        $response = $this->withHeaders($this->headers)->put($this->getRoute("update", [$this->default_resource_id]), $this->getInvalidUpdateData());

        $response->assertStatus(422);
        $response->assertJsonFragment([
            "status" => "error"
        ]);
    }

    public function testShouldReturnErrorIfUpdatedInvalidResource(): void
    {
        $response = $this->withHeaders($this->headers)->put($this->getRoute("update", [$this->fake_resource_id]), $this->getUpdateData());

        $response->assertNotFound();
        $response->assertJsonFragment([
            "status" => "error",
            "message" => $this->lang("not-found")
        ]);
    }

    public function testAdminCanUpdateStatus(): void
    {
        if ( !$this->has_status_test ) $this->markTestSkipped("Status method not available.");

        $current_status = $this->model::findOrFail($this->default_resource_id)->status;
        $response = $this->withHeaders($this->headers)->put($this->getRoute("update-status", [$this->default_resource_id]));
        $updated_status = $this->model::findOrFail($this->default_resource_id)->status;
        
        $this->assertTrue((bool) $current_status != (bool) $updated_status);
        $response->assertOk();
        $response->assertJsonFragment([
            "status" => "success",
            "message" => $this->lang("status-success")
        ]);

        $random_status = (bool) rand(0, 1);
        $response = $this->withHeaders($this->headers)->put($this->getRoute("update-status", [$this->default_resource_id]), ["status" => $random_status]);
        $updated_status = $this->model::findOrFail($this->default_resource_id)->status;

        $this->assertTrue((bool) $random_status == (bool) $updated_status);
    }

    /**
     * DELETE method tests
     * 
     * 1. Assert if resource can be deleted.
     * 2. Assert if the application returns error when trying to delete invalid resource.
     */

    public function testAdminCanDeleteResource(): void
    {
        $response = $this->withHeaders($this->headers)->delete($this->getRoute("destroy", [$this->default_resource_id]));

        $response->assertOk();
        $response->assertJsonFragment([
            "status" => "success",
            "message" => $this->lang("delete-success")
        ]);
    }

    public function testAdminCanDeleteInvalidResource(): void
    {
        $response = $this->withHeaders($this->headers)->delete($this->getRoute("destroy", [$this->fake_resource_id]));

        $response->assertNotFound();
        $response->assertJsonFragment([
            "status" => "error",
            "message" => $this->lang("not-found")
        ]);
    }
}
