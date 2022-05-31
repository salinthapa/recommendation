<?php

namespace Modules\User\Repositories;

use Exception;
use Modules\User\Entities\User;
use Illuminate\Support\Facades\Auth;
use Modules\User\Transformers\UserResource;
use Modules\Core\Repositories\BaseRepository;
use Illuminate\Validation\ValidationException;

class UserRepository extends BaseRepository
{
    public function __construct(User $user)
    {
        $this->model = $user;
        $this->model_name = "User";
        $this->model_key = "user";
        $this->rules = [
            "role_id" => "required",
            "first_name" => "required",
            "last_name" => "required",
            "qualification" => "required",
            "gym_id" => "nullable",
            "email" => "required|email|unique:users,email",
            "password" => "required|confirmed",
            "phone" => "required|unique:users,phone",
            "status" => "sometimes|boolean"
        ];
    }

    public function validateLogin(object $request): array
    {
        try {
            $data = $request->validate([
                "email" => "required|email|exists:users,email",
                "password" => "required"
            ]);
        } catch (Exception $exception) {
            throw $exception;
        }

        return $data;
    }

    public function getJwtToken(array $credentials): array
    {
        try {
            $jwtToken = Auth::attempt($credentials);
            if (!$jwtToken) throw ValidationException::withMessages(["email" => __("login-error")]);

            $token_data = [
                "token" => $jwtToken,
                "user" => new UserResource(auth()->user())
            ];
        } catch (Exception $exception) {
            throw $exception;
        }

        return $token_data;
    }
}
