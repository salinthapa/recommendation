<?php

namespace Modules\Role\Http\Controllers;

use Exception;
use Illuminate\Http\Request;
use Modules\Role\Entities\Role;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Resources\Json\JsonResource;
use Modules\Core\Http\Controllers\BaseController;
use Modules\Role\Repositories\RoleRepository;
use Modules\Role\Transformers\RoleResource;

class RoleController extends BaseController
{
    protected $repository;

    public function __construct(Role $role, RoleRepository $roleRepository)
    {
        $this->model = $role;
        $this->model_name = "Role";
        $this->repository = $roleRepository;

        $this->restrict = ["index", "show", "store", "update", "destroy"];

        parent::__construct();
    }

    public function collection(object $resources): JsonResource
    {
        return RoleResource::collection($resources);
    }

    public function resource(object $resource): JsonResource
    {
        return new RoleResource($resource);
    }

    public function index(Request $request): JsonResponse
    {
        try
        {
            $fetched = $this->repository->fetchAll($request);
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
            $data = $this->repository->validateData($request);
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
            $fetched = $this->repository->fetch($id);
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
            $data = $this->repository->validateData($request);
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
}
