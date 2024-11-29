import re
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from mts_vis.storage import MTSStorage
from typing import List, Optional

import numpy as np

app = FastAPI()

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

path = None
storage = None
objects = None

class PathModel(BaseModel):
    path: str

class NameModel(BaseModel):
    name: str

class TimeMeanStdRequest(BaseModel):
    name: str
    dim: int
    positions: List[int]

@app.post("/loadFromPath")
async def load_from_path(path_model: PathModel):
    global storage, objects
    storage = MTSStorage(path_model.path)
    storage.load()
    objects = storage.objects
    return {"status": "Done"}

@app.post("/getObjectNames")
async def get_object_names():
    global storage
    if storage is None:
        raise HTTPException(status_code=400, detail="Storage not loaded")
    object_names = storage.objects_names()
    return {"object_names": object_names}

@app.post("/getObjectInfo")
async def get_object_info(name_model: NameModel):
    global storage
    if storage is None:
        raise HTTPException(status_code=400, detail="Storage not loaded")
    if name_model.name not in storage.objects:
        raise HTTPException(status_code=404, detail="Object not found")
    object_info = storage.get_object_info(name_model.name)
    return {"object_info": object_info}

@app.post("/getTimeMeanStd")
async def get_time_mean_std(request: TimeMeanStdRequest):
    global storage
    if storage is None:
        raise HTTPException(status_code=400, detail="Storage not loaded")
    if request.name not in storage.objects:
        raise HTTPException(status_code=404, detail="Object not found")
    mean, std = storage.get_time_mean_std(request.name, request.dim, request.positions)
    return {"mean": mean.tolist(), "std": std.tolist()}

