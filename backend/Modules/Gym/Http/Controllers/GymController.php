<?php

namespace Modules\Gym\Http\Controllers;

use Exception;
use Illuminate\Http\Request;
use Modules\Gym\Entities\Gym;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Resources\Json\JsonResource;
use Modules\Core\Http\Controllers\BaseController;
use Modules\Gym\Repositories\GymRepository;
use Modules\Gym\Transformers\GymResource;

class GymController extends BaseController
{
    protected $repository;

    public function __construct(Gym $gym, GymRepository $gymRepository)
    {
        $this->model = $gym;
        $this->model_name = "Gym";
        $this->repository = $gymRepository;

        $this->restrict = ["index", "show", "store", "update", "destroy"];

        parent::__construct();
    }

    public function collection(object $resources): JsonResource
    {
        return GymResource::collection($resources);
    }

    public function resource(object $resource): JsonResource
    {
        return new GymResource($resource);
    }

    public function index(Request $request): JsonResponse
    {
        try {
            $fetched = $this->repository->fetchAll($request);
        } catch (Exception $exception) {
            return $this->handleException($exception);
        }

        return $this->successResponse($this->collection($fetched), $this->lang("fetch-all-success"));
    }

    public function store(Request $request): JsonResponse
    {
        try {
            $data = $this->repository->validateData($request);
            $created = $this->repository->store($data);
        } catch (Exception $exception) {
            return $this->handleException($exception);
        }

        return $this->successResponse($this->resource($created), $this->lang("store-success"), 201);
    }

    public function show(int $id): JsonResponse
    {
        try {
            $fetched = $this->repository->fetch($id);
        } catch (Exception $exception) {
            return $this->handleException($exception);
        }

        return $this->successResponse($this->resource($fetched), $this->lang("fetch-success"));
    }

    public function update(Request $request, int $id): JsonResponse
    {
        try {
            $data = $this->repository->validateData($request);
            $updated = $this->repository->update($data, $id);
        } catch (Exception $exception) {
            return $this->handleException($exception);
        }

        return $this->successResponse($this->resource($updated), $this->lang("update-success"));
    }

    public function destroy(int $id): JsonResponse
    {
        try {
            $this->repository->delete($id);
        } catch (Exception $exception) {
            return $this->handleException($exception);
        }

        return $this->successResponseMessage($this->lang("delete-success"));
    }
}
