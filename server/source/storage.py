import numpy as np
import os



class MTSStorage:
    def __init__(self, filename):
        self.filename = filename
        self.objects = {}
    
    # mts with shape N, T, D
    def add_mts(self, name, mts, dimensions = [], coords = {}, labels = {},  labelsNames = {}):

        self.objects[name] = {'mts': mts}
        if len(coords) != 0:
            self.objects[name]['coords'] = {}
            for k, v in coords.items():
                self.objects[name]['coords'][k] = np.array(v)
        if len(labels) != 0:
            self.objects[name]['labels'] = {}
            for k, v in labels.items():
                self.objects[name]['labels'][k] = np.array(v).astype(int)
                
        if len(dimensions) != 0:
            self.objects[name]['dimensions'] = np.array(dimensions)
            
        if len(labelsNames) != 0:
            self.objects[name]['labelsNames'] = labelsNames
            # for k, v in labelsNames.items():
            #     self.objects[name]['labelsNames'][k] = v
    
    # saves objects dict as pickle file
    def save(self):
        np.save(self.filename, self.objects)
    
    def load(self):
        if os.path.exists(self.filename + '.npy'):
            self.objects = np.load(self.filename + '.npy', allow_pickle=True)
            self.objects = self.objects[()]
    
    def delete(self):
        if os.path.exists(self.filename + '.npy'):
            os.remove(self.filename + '.npy')
            
    
    
    