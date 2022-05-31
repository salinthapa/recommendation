<?php

namespace Modules\User\Entities;

use Modules\Role\Entities\Role;
use Modules\Gym\Entities\Gym;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Tymon\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable implements JWTSubject
{
    use HasFactory, Notifiable;

    protected $guarded = [];
    protected $hidden = ["password"];
    protected $with = ["role", "gym"];

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims(): array
    {
        return [];
    }

    protected static function newFactory()
    {
        return \Modules\User\Database\factories\UserFactory::new();
    }

    public function role(): BelongsTo
    {
        return $this->belongsTo(Role::class);
    }
    public function gym(): BelongsTo
    {
        return $this->belongsTo(Gym::class);
    }

    public function getFullNameAttribute(): string
    {
        return ucwords("{$this->first_name} {$this->last_name}");
    }
}
