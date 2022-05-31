<?php

namespace Modules\Core\Policies;

use Illuminate\Support\Str;
use Illuminate\Auth\Access\HandlesAuthorization;

class BasePolicy
{
    use HandlesAuthorization;
    public $model_key;

    public function permissions(): ?array
    {
        return auth()->user()->role->permissions;
    }

    public function action(string $action): string
    {
        return "{$this->model_key}.{$action}";
    }

    public function hasPermission(string $action): bool
    {
        if ( !$this->permissions() ) return false;
        return in_array($this->action($action), $this->permissions());
    }

    public function index(): bool
    {
        return $this->hasPermission(__FUNCTION__);
    }
    
    public function show(): bool
    {
        return $this->hasPermission(__FUNCTION__);
    }

    public function store(): bool
    {
        return $this->hasPermission(__FUNCTION__);
    }

    public function update(): bool
    {
        return $this->hasPermission(__FUNCTION__);
    }

    public function destroy(): bool
    {
        return $this->hasPermission(__FUNCTION__);
    }

    public function updateStatus(): bool
    {
        return $this->hasPermission(Str::kebab(__FUNCTION__));
    }
}
