<?php

namespace Modules\Core\Http\Controllers;

use Exception;
use Illuminate\Support\Str;
use Illuminate\Http\JsonResponse;
use Illuminate\Routing\Controller;
use Modules\Core\Traits\ApiResponse;
use Illuminate\Database\QueryException;
use Illuminate\Validation\ValidationException;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Symfony\Component\HttpKernel\Exception\UnauthorizedHttpException;

class BaseController extends Controller
{
    use ApiResponse;

    protected array $exception_statuses;
    public $model, $model_name;
    public array $restrict = [];

    public function __construct()
    {
        $this->exception_statuses = [
            ValidationException::class => 422,
            ModelNotFoundException::class => 404,
            QueryException::class => 400,
            UnauthorizedHttpException::class => 403
        ];

        $this->setMiddlewares();
    }

    public function getModelClass(): string
    {
        return get_class($this->model);
    }

    public function setMiddlewares(): void
    {
        try
        {
            $default_policies = ["index", "show", "store", "update", "destroy", "update-status"];

            foreach ($default_policies as $policy) {
                if (in_array($policy, $this->restrict)) {
                    $method = Str::camel($policy);
                    $this->middleware("can:{$policy},{$this->getModelClass()}")->only($method);
                }
            }
        }
        catch ( Exception $exception )
        {
            throw $exception;
        }
    }

    public function lang(string $key, ?string $name = null): string
    {
        $name = $name ?? $this->model_name;
        return [
            "fetch-all-success" => __("core::response.fetch-success", ["name" => Str::plural($name)]),
            "fetch-success" => __("core::response.fetch-success", ["name" => $name]),
            "store-success" => __("core::response.store-success", ["name" => $name]),
            "update-success" => __("core::response.update-success", ["name" => $name]),
            "delete-success" => __("core::response.delete-success", ["name" => $name]),
            "status-success" => __("core::response.status-success", ["name" => $name]),
            "assign-success" => __("core::response.assign-success", ["name" => $name]),

            "not-found" => __("core::response.not-found", ["name" => $name]),
            "login-success" => __("core::response.login-success", ["name" => $name]),
            "login-error" => __("core::response.login-error", ["name" => $name]),
            "register-success" => __("core::response.register-success", ["name" => $name]),
            "not-authenticated" => __("core::response.not-authenticated", ["name" => $name]),
            "logout-success" => __("core::response.logout-success", ["name" => $name])
        ][$key] ?? $key;
    }

    public function getExceptionStatus(object $exception): int
    {
        return $this->exception_statuses[get_class($exception)] ?? 500;
    }

    public function getExceptionMessage(object $exception): string
    {
        switch(get_class($exception)){
            case ValidationException::class:
                $exception_message = json_encode($exception->errors());
            break;

            case ModelNotFoundException::class:
                $exception_message = $this->lang("not-found");
            break;

            default:
                $exception_message = $exception->getMessage();
            break;
       }
       
       return $exception_message;
    }

    public function handleException(object $exception): JsonResponse
    {
        return $this->errorResponse($this->getExceptionMessage($exception), $this->getExceptionStatus($exception));
    }
}
