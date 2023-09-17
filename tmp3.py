import torch
import torch.nn.functional as F
from constants import BERT_CLS_TOKEN, BERT_SEP_TOKEN, BERT_PAD_TOKEN
import numpy as np
from scipy.spatial import distance
from b import (
    no_tenfact,
    matlab_eigs,
    matlab_eigs2
)

def compute_grads(model, x_embeds, y_labels, create_graph=False, return_pooler=False, return_first_token_tensor=False, cheat=False, debug=False):
    outs, ori_pooler_dense_input = model(
        inputs_embeds=x_embeds, 
        labels=y_labels, 
        return_first_token_tensor=True)
    gradients = torch.autograd.grad(outs.loss, model.parameters(), create_graph=create_graph, allow_unused=True)

    if not return_pooler:
        if return_first_token_tensor:
            return gradients, ori_pooler_dense_input
        else:
            return gradients
        
    sub_dimension = 100 
    m = 30000-768
    d = sub_dimension
    B = len(x_embeds)
    
    # activarteion
    # even => even => 特殊处理
    # odd => sigmoid/odd => 特殊处理 
    # squer + cubic => no 特殊处理
    
    g = gradients[-2].cpu().numpy()[1][768:].reshape(m)
    W = model.bert.pooler.dense.weight.data[768:, :100].cpu().numpy() # W => m x d

    M = np.zeros((d, d))     
    import pdb; pdb.set_trace()

    # for i in range(d): #768
    #     for j in range(d): #768
    #         M[i, j] = np.sum(g * W[:, i] * W[:, j])
    #         if i == j:
    #             M[i, i] = M[i, i] - np.sum(g)

    # A = np.zeros(d)
    # A[0] = 1
    # sum_ak_wk = np.dot(W, A) # mxd, d => m
    # for i in range(d):
    #     for j in range(d):
    #         M[i, j] = np.sum(g * W[:, i] * W[:, j] * sum_ak_wk)
    #         if i == j:
    #             M[i, j] -= np.sum(g * sum_ak_wk)
    #         if i != j:
    #             M[i, j] += np.sum(g * W[:, i] * A[j])
    #             M[i, j] += np.sum(g * W[:, j] * A[i])

    # A = np.zeros(m)
    # A[0] = 1
    # for i in rangej:j:
    #     for j in range(d):
    #         M[i, j] = np.sum(g * np.dot(W[:, i], W[:, j]) * np.dot(A, W[:, j]))
    #         if i == j:
    #             M[i, j] -= np.sum(g * (np.dot(W[:, j], A) + np.dot(W[:, i], A) + np.dot(A, W[:, j])))

    # F = np.zeros((d, d, d))    
    # for i in range(d): #768
    #     for j in range(d): #768
    #         for k in range(d): #768
    #             F[i, j, k] = np.sum(g * W[:, i] * W[:, j] * W[:, k])
    #             if i == j:
    #                 F[i, j, k] = F[i, j, k] - np.sum(g * W[:, k])
    #             if i == k:
    #                 F[i, j, k] = F[i, j, k] - np.sum(g * W[:, j])
    #             if j == k:
    #                 F[i, j, k] = F[i, j, k] - np.sum(g * W[:, i])
    
    # M = np.zeros((d, d))     
    # A = np.zeros(d)
    # A[0] = 1
    # for i in range(d):
    #     for j in range(d):
    #         M[i, j] = np.sum(F[i, j, :] * A) 

    A = np.zeros(d)
    A[0] = 1
    sum_ak_wk = np.dot(W, A) # mxd, d => m
    for i in range(d):
        for j in range(d):
            # Compute the tensor product contribution
            tensor_prod_contribution = np.sum(g * W[:, i] * W[:, j] * sum_ak_wk)
            
            # Compute the corrections from Xtilde{otimes}I
            correction = 0
            if i == j:
                correction += np.sum(g * sum_ak_wk)
            correction += np.sum(g * W[:, i] * A[j])
            correction += np.sum(g * W[:, j] * A[i])
            
            # Update M[i, j]
            M[i, j] = tensor_prod_contribution - correction

    V, D = matlab_eigs(M, B)
    WV = W @ V

    # T = np.zeros((B, B, B))
    # for i in range(B):
    #     for j in range(i, B):
    #         for k in range(j, B):
    #             T[i, j, k] = np.sum(g * WV[:, i] * WV[:, j] * WV[:, k])
    #             T[i, k, j] = T[i, j, k]
    #             T[j, i, k] = T[i, j, k]
    #             T[j, k, i] = T[i, j, k]
    #             T[k, i, j] = T[i, j, k]
    #             T[k, j, i] = T[i, j, k]

    # for i in range(B):
    #     for j in range(B):
    #         aa = np.sum(g * WV[:, i])
    #         T[i, j, j] = T[i, j, j] - aa
    #         T[j, i, j] = T[j, i, j] - aa
    #         T[j, j, i] = T[j, j, i] - aa

    # T = T / m


    # tensor
    import pdb; pdb.set_trace()
    T = np.zeros((B, B, B))
    for i in range(0, B):
        for j in range(0, B):
            for k in range(0, B):
                T[i, j, k] = np.sum(g * WV[:, i] * WV[:, j] * WV[:, k])
                if j==k:
                    T[i,j,k]=T[i,j,k]-np.sum(g*WV[:, i])
                if i==j:
                    T[i,j,k]=T[i,j,k]-np.sum(g*WV[:, k])
                if i==k:
                    T[i,j,k]=T[i,j,k]-np.sum(g*WV[:, j])
    T=T/m

    rec_X, _, misc = no_tenfact(T, 100, B)
    new_recX = V @ rec_X

    ######################################################################
    highest, highest_index = find_highest_indices(B, new_recX, ori_pooler_dense_input)
    print("average of cosine similarity",sum(highest)/B)
    print("highest_index", highest_index)
    print("highest", highest)

    pooler_target = torch.from_numpy(new_recX.transpose()).cuda()
    pooler_target = pooler_target[torch.tensor(highest_index)]

    import pdb; pdb.set_trace()
    return gradients, pooler_target, sum(highest)/B, highest 

def check_cosine_similarity_for_1_sample(recover, target):
    ######################################################################
    # 768 => 1
    input = target[:, :100]
    input = input / torch.linalg.norm(input, ord=2, dim=1, keepdim=True)
    input = input.detach().cpu().numpy()

    # 100 => 1
    # new_recXX = (new_recX / np.linalg.norm(new_recX, ord=2, axis=0)).transpose()
    new_recXX = recover.transpose()
    cosin_sim = 1-distance.cosine(new_recXX.reshape(-1), input.reshape(-1))
    # print(f"cosin similarity: {cosin_sim}",
    #     f"normalized error: {np.sum((new_recXX.reshape(-1) - input.reshape(-1))**2)}")
    
    for i in range(1):
        recover[:, i] = -recover[:, i]
    
    # new_recXX = (new_recX / np.linalg.norm(new_recX, ord=2, axis=0)).transpose()
    new_recXX = recover.transpose() 
    cosin_sim = 1-distance.cosine(new_recXX.reshape(-1), input.reshape(-1))
    # print(f"cosin similarity: {cosin_sim}",
    #     f"normalized error: {np.sum((new_recXX.reshape(-1) - input.reshape(-1))**2)}")
    ######################################################################
    return abs(cosin_sim)

# ground truth
# recovered truth cosine sim 0.6, 0.7 => loss 1-0.36=0.64 1-0.49=0.51
# training feature if (training feature and recover truth 间loss高于 0.64 才优化，other wise 不优化)

def find_highest_indices(B, new_recX, ori_pooler_dense_input):
    highest = [0] * B
    highest_index = [-1] * B
    index_score_list = []
    index_assignments = {}  # dictionary to keep track of which i an index j was assigned to

    for i in range(B):
        for j in range(B):
            target = ori_pooler_dense_input[i:i+1, :]
            recover = new_recX[:, j:j+1]
           
            cosine_similarity = check_cosine_similarity_for_1_sample(
                recover,
                target
            )
            index_score_list.append((cosine_similarity, i, j))

    index_score_list.sort(reverse=True)  # sort in decreasing order

    for score, i, j in index_score_list:
        if j not in index_assignments and highest_index[i] == -1:
        # if highest_index[i] == -1: 
            highest[i] = score
            highest_index[i] = j
            index_assignments[j] = i  # record the assignment of j to i

    return highest, highest_index

   

