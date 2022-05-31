<?php

namespace Modules\Role\Transformers;

use Illuminate\Http\Resources\Json\JsonResource;

class RoleResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            "id" => $this->id,
            "name" => $this->name,
            "permissions" => $this->permissions,
            "created_at" => $this->created_at->format("dS F, Y H:i a"),
            "created_at_diff" => $this->created_at->diffForHumans()
        ];
    }
}
