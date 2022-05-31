<?php

namespace Modules\User\Http\Controllers;

use Exception;
use Illuminate\Http\Request;
use Modules\User\Entities\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;
use Modules\User\Transformers\UserResource;
use Modules\User\Repositories\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;
use Modules\Core\Http\Controllers\BaseController;

class UserController extends BaseController
{
    protected $repository;

    public function __construct(User $user, UserRepository $userRepository)
    {
        $this->model = $user;
        $this->model_name = "User";
        $this->repository = $userRepository;

        $this->restrict = ["index", "show", "update", "store", "destroy", "update-status"];
        parent::__construct();
    }

    public function collection(object $resources): JsonResource
    {
        return UserResource::collection($resources);
    }

    public function resource(object $resource): JsonResource
    {
        return new UserResource($resource);
    }

    public function index(Request $request): JsonResponse
    {
        try
        {
            $fetched = $this->repository->fetchAll($request, ["role"]);
        }
        catch ( Exception $exception )
        {
            return $this->handleException($exception);
        }
        
        return $this->successResponse($this->collection($fetched), $this->lang("fetch-all-success"));
    }

    public function store(Request $request): JsonResponse
    {
        try
        {
            $data = $this->repository->validateData($request, [], function ($data) {
                return ["password" => Hash::make($data["password"])];
            });
            $created = $this->repository->store($data);
        }
        catch ( Exception $exception )
        {
            return $this->handleException($exception);
        }

        return $this->successResponse($this->resource($created), $this->lang("store-success"), 201);
    }

    public function show(int $id): JsonResponse
    {
        try
        {
            $fetched = $this->repository->fetch($id, ["role"]);
        }
        catch ( Exception $exception )
        {
            return $this->handleException($exception);
        }

        return $this->successResponse($this->resource($fetched), $this->lang("fetch-success"));
    }

    public function update(Request $request, int $id): JsonResponse
    {
        try
        {
            $data = $this->repository->validateData($request, [
                "email" => "required|email|unique:users,email,{$id}",
                "phone" => "required|unique:users,phone,{$id}"
            ], function($data) {
                return ["password" => Hash::make($data["password"])];
            });
            $updated = $this->repository->update($data, $id);
        }
        catch ( Exception $exception )
        {
            return $this->handleException($exception);
        }

        return $this->successResponse($this->resource($updated), $this->lang("update-success"));
    }

    public function destroy(int $id): JsonResponse
    {
        try
        {
            $this->repository->delete($id);
        }
        catch ( Exception $exception )
        {
            return $this->handleException($exception);
        }

        return $this->successResponseMessage($this->lang("delete-success"));
    }

    public function register(Request $request): JsonResponse
    {
        try
        {
            $data = $this->repository->validateData($request, [], function ($data) {
                return ["password" => Hash::make($data["password"])];
            });
            $created = $this->repository->store($data);
        }
        catch ( Exception $exception )
        {
            return $this->handleException($exception);
        }

        return $this->successResponse($this->resource($created), $this->lang("register-success"), 201);
    }

    public function updateStatus(Request $request, int $id): JsonResponse 
    {
        try 
        {
            $updated = $this->repository->updateStatus($id, $request);
        } catch ( Exception $exception)
        {
            return $this->handleException($exception);
        }

        return $this->successResponse($this->resource($updated), $this->lang("status-success"));
    }
}
