<?php

namespace Modules\User\Http\Controllers;

use Exception;
use Illuminate\Http\Request;
use Modules\User\Entities\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Modules\User\Transformers\UserResource;
use Modules\User\Repositories\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;
use Modules\Core\Http\Controllers\BaseController;

class SessionController extends BaseController
{
    protected $repository;

    public function __construct(User $user, UserRepository $userRepository)
    {
        $this->model = $user;
        $this->model_name = "User";
        $this->repository = $userRepository;

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

    public function login(Request $request): JsonResponse
    {
        try 
        {
            $data = $this->repository->validateLogin($request);
            $token_data = $this->repository->getJwtToken($data);
        }
        catch ( Exception $exception ) 
        {
            return $this->handleException($exception);
        }

        return $this->successResponse($token_data, $this->lang("login-success"));
    }

    public function logout(): JsonResponse
    {
        try
        {
            Auth::logout();
        }
        catch ( Exception $exception ) 
        {
            return $this->handleException($exception);
        }

        return $this->successResponseMessage($this->lang("logout-success")); 
    }

    public function me(): JsonResponse
    {
        try 
        {
            $data = auth()->user();
        }
        catch ( Exception $exception ) 
        {
            return $this->handleException($exception);
        }

        return $this->successResponse($this->resource($data), $this->lang("logout-success"));
    }
}
