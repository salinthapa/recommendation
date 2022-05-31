<?php

namespace Modules\Core\Repositories;

use Exception;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Event;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class BaseRepository
{
    protected object $model;
    protected ?string $model_key;
    protected ?string $model_name;
    protected array $rules;
    protected int $pagination_limit = 25;

    public function model(): Model
    {
        return $this->model;
    }

    public function fetchAll(object $request, array $with = [], ?callable $callback = null): object
    {
        Event::dispatch("{$this->model_key}.fetch-all.before");

        try
        {
            $this->validateFiltering($request);
            $rows = ($callback) ? $callback() : null;
            $hash = md5(json_encode($request->all()));
           
            $fetched = Cache::tags(["{$this->model_key}.all", $hash])->rememberForever("{$this->model_key}.all.{$hash}", function () use ($request, $with, $rows) {
                return $this->getFiltered($request, $with, $rows);
            });
        }
        catch( Exception $exception )
        {
            throw $exception;
        }

        Event::dispatch("{$this->model_key}.fetch-all.after", $fetched);

        return $fetched;
    }

    public function fetch(int $id, array $with = [], ?callable $callback = null): object
    {
        Event::dispatch("{$this->model_key}.fetch-single.before");

        try
        {
            $rows = $this->model;
            if ($callback) $rows = $callback();
            $hash = md5($id);
            if ($with !== []) {
                $rows = $rows->with($with);
                $hash = md5(json_encode($with));
            }

            $fetched = Cache::tags(["{$this->model_key}.{$id}", $hash])->rememberForever("{$this->model_key}.{$id}.{$hash}", function () use ($rows, $id) {
                return $rows->findOrFail($id);
            });
        }
        catch ( Exception $exception )
        {
            throw $exception;
        }

        Event::dispatch("{$this->model_key}.fetch-single.after", $fetched);

        return $fetched;
    }

    public function store(array $data, ?callable $callback = null): object
    {
        DB::beginTransaction();
        Event::dispatch("{$this->model_key}.store.before");

        try
        {
            $created = $this->model->create($data);
            if ($callback) $callback($created);
        }
        catch ( Exception $exception )
        {
            DB::rollBack();
            throw $exception;
        }

        Event::dispatch("{$this->model_key}.store.after", $created);
        DB::commit();
        
        $this->flushAllCache();

        return $created;
    }

    public function update(array $data, int $id, ?callable $callback = null): object
    {
        DB::beginTransaction();
        Event::dispatch("{$this->model_key}.update.before");

        try
        {
            $updated = $this->model->findOrFail($id);
            $updated->fill($data);
            $updated->save();

            if ($callback) $callback($updated);
        }
        catch ( Exception $exception )
        {
            DB::rollBack();
            throw $exception;
        }

        Event::dispatch("{$this->model_key}.update.after", $updated);
        DB::commit();

        $this->flushAllCache($id);
        $this->flushAllCache();

        return $updated;
    }

    public function delete(int $id, ?callable $callback = null): object
    {
        DB::beginTransaction();
        Event::dispatch("{$this->model_key}.delete.before");

        try
        {
            $deleted = $this->model->findOrFail($id);
            if ($callback) $callback($deleted);
            $deleted->delete();
        }
        catch ( Exception $exception )
        {
            DB::rollBack();
            throw $exception;
        }

        Event::dispatch("{$this->model_key}.delete.after", $deleted);
        DB::commit();

        $this->flushAllCache($id);
        $this->flushAllCache();

        return $deleted;
    }

    public function validateFiltering(object $request): array
    {
        try
        {
            $rules = [
                "limit" => "sometimes|numeric",
                "page" => "sometimes|numeric",
                "sort_by" => "sometimes",
                "sort_order" => "sometimes|in:asc,desc",
                "search" => "sometimes|string|min:1"
            ];
    
            $messages = [
                "limit.numeric" => "Limit must be a number.",
                "page.numeric" => "Page must be a number.",
                "sort_order.in" => "Order must be 'asc' or 'desc'.",
                "search.string" => "Search query must be string.",
                "search.min" => "Search query must be at least 1 character."
            ];

            $data = $request->validate($rules, $messages);
        }
        catch ( Exception $exception )
        {
            throw $exception;
        }
        
        return $data;
    }

    public function getFiltered(object $request, array $with = [], ?object $rows = null): object
    {
        try
        {
            $sort_by = $request->sort_by ?? "id";
            $sort_order = $request->sort_order ?? "desc";
            $limit = (int) $request->limit ?? $this->pagination_limit;

            $rows = $rows ?? $this->model::query();
            if ($with !== []) $rows = $rows->with($with);
            if ($request->has("search")) $rows = $rows->whereLike($this->model::$SEARCHABLE, $request->search);
            $rows = $rows->orderBy($sort_by, $sort_order);

            $resources = $rows->paginate($limit)->appends($request->except("page"));
        }
        catch ( Exception $exception )
        {
            throw $exception;
        }

        return $resources;
    }

    public function rules(array $merge = []): array
    {
        return array_merge($this->rules, $merge);
    }

    public function validateData(object $request, array $merge = [], ?callable $callback = null): array
    {
        $data = $request->validate($this->rules($merge));
        $append_data = $callback ? $callback($request) : [];

        return array_merge($data, $append_data);
    }

    public function uploadFile(array $files, bool $random = false, ?string $folder = null, ?string $description = null): array
    {
        try 
        {
            $file_infos = [];

            foreach($files as $file) {
                $original_name = $file->getClientOriginalName();
                $file_extension = pathinfo($original_name)["extension"];
                $identifier = Str::random(5);
                $file_identifier = Str::random(10);

                $file_name = $random ? "{$file_identifier}.{$file_extension}" : $original_name;

                $folder = $folder ?? "images";
                $location = "{$folder}/{$identifier}";

                $file_path = Storage::putFileAs($location, $file, $file_name);
                $file_info = getimagesize(Storage::path($file_path));

                $file_infos[] = [
                    "size" => Storage::size($file_path),
                    "path" => $file_path,
                    "mime" => $file_info["mime"],
                    "width" => $file_info[0],
                    "height" => $file_info[1],
                    "dimension" => "{$file_info[0]} x {$file_info[1]}",
                    "orignal_name" => $original_name,
                    "description" => $description ?? $original_name
                ];
            }
        }
        catch ( Exception $exception ) 
        {
            throw $exception;
        }
        return $file_infos;    
    }

    public function flushAllCache(string $key = "all"): void
    {
        try 
        {
            Cache::tags(["{$this->model_key}.{$key}"])->flush();
        }
        catch ( Exception $exception ) 
        {
            throw $exception;
        }
    }

    public function updateStatus(int $id, object $request): object
    {
        try 
        {    
            $request->validate([
                "status" => "sometimes|boolean"
            ]);
            $status = $request->status;
            $resource = $this->model::findOrFail($id);

            if ($request->status === null) {
                $status = !$resource->status;
            }
            
            $resource->fill([
                "status" => $status
            ]);
            $resource->save();
        } 
        catch ( Exception $exception ) 
        {
            throw $exception;
        }

        $this->flushAllCache($id);
        $this->flushAllCache();

        return $resource;
    }
}
