import numpy as np
import os
import pickle
from typing import Any, Dict, List, Optional

class MTSStorage:
    """
        Class to store multiple MTS objects in a single file

        Each MTS object is stored as a dictionary with the following keys:
        - 'mts': Numpy array of shape N, T, D
        - 'dimensions' (optional): String with the name of the dimensions e.g. ['dim1', 'dim2', 'dim3']
        - 'projections': Dictionary with multiple 2D projections of the MTS object e.g. 'pca', 'tsne', 'umap' e.g. {'pca': np.zeros(N, 2), 'tsne': np.zeros(N, 2), 'umap': np.zeros(N, 2)}
        - 'labels' (optional): Dictionary with labels for each time series e.g. {'type1': [0, 1, 0, 1 ...], 'type2': [1, 2, 0, 2 ...]}
        - 'labelsNames' (optional): Dictionary with the names of the labels e.g. {'type1': {0: 'Cluster 1', 1: 'Cluster 2'}, 'type2': {0: 'Cluster 1', 1: 'Cluster 2', 2: 'Cluster 3'}}
    """
    def __init__(self, filename: str):
        self.filename = filename
        self.objects: Dict[str, Any] = {}
        # Removed self.data as it's unused
    
    # mts with shape N, T, D
    def add_mts(self, name: str, mts: Any,
                dimensions: Optional[List[str]] = None,
                projections: Optional[Dict[str, Any]] = None,
                labels: Optional[Dict[str, List[int]]] = None,
                labelsNames: Optional[Dict[str, Dict[int, str]]] = None):
        # Set default values if None
        if dimensions is None:
            dimensions = []
        if projections is None:
            projections = {}
        if labels is None:
            labels = {}
        if labelsNames is None:
            labelsNames = {}

        self.objects[name] = {'mts': mts}
        if projections:
            self.objects[name]['projections'] = {k: np.array(v) for k, v in projections.items()}
        if labels:
            self.objects[name]['labels'] = {k: np.array(v).astype(int) for k, v in labels.items()}
        if dimensions:
            self.objects[name]['dimensions'] = np.array(dimensions)
        if labelsNames:
            self.objects[name]['labelsNames'] = labelsNames
    
    # saves objects dict as numpy file
    def save(self):
        np.save(self.filename, self.objects, allow_pickle=True)
    
    def load(self):
        if os.path.exists(self.filename):
            self.objects = np.load(self.filename, allow_pickle=True).item()
            print('Object loaded')
        else:
            print('Error: File does not exist')
    
    def delete(self):
        if os.path.exists(self.filename):
            os.remove(self.filename)

    # * ------------------------------- Methods for FastAPI ------------------------------- *
    def objects_names(self):
        return list(self.objects.keys())
    
    # Converts the object to a dictionary that can be jsonified
    def get_object_info(self, name: str):
        object = self.objects[name]
        
        data_map = {}
        data_map['shape'] = object['mts'].shape
        data_map['projections'] = {k: v.flatten().tolist() for k, v in object['projections'].items()}
        data_map['labels'] = {k: v.tolist() for k, v in object['labels'].items()}
        data_map['labelsNames'] = object['labelsNames']
        data_map['dimensions'] = object['dimensions'].tolist()
        return data_map

    
    def get_time_mean_std(self, name: str, dim: int, positions: List[int] = None):
        object = self.objects[name]
        mts = object['mts']
        if positions is not None:
            mts = mts[positions]

        ts = mts[:, :, dim]
        mean = np.mean(ts, axis=0)
        std = np.std(ts, axis=0)
        return mean, std



