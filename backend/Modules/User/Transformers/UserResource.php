<?php

namespace Modules\User\Transformers;

use Illuminate\Http\Resources\Json\JsonResource;
use Modules\Role\Transformers\RoleResource;
use Modules\Gym\Transformers\GymResource;

class UserResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            "id" => $this->id,
            "role" => new RoleResource($this->whenLoaded("role")),
            "role_id" => $this->role_id,
            "full_name" => $this->full_name,
            "first_name" => $this->first_name,
            "last_name" => $this->last_name,
            "qualification" => $this->qualification,
            "email" => $this->email,
            "phone" => $this->phone,
            "gym" => new GymResource($this->whenLoaded("gym")),
            "gym_id" => $this->gym_id,
            "password" => $this->password,

            "confirmtion_password" => $this->password,
            "status" => (bool) $this->status,
            "created_at" => $this->created_at->format("dS F, Y H:i a"),
            "created_at_diff" => $this->created_at->diffForHumans()
        ];
    }
}
